#!/usr/bin/env python3
"""Generate ElevenLabs speech from local voice profiles."""

from __future__ import annotations

import argparse
import datetime as dt
import json
import os
from pathlib import Path
import re
import sys
from typing import Any, Optional
from urllib.error import HTTPError, URLError
from urllib.parse import urlencode
from urllib.request import Request, urlopen


API_BASE = "https://api.elevenlabs.io"
DEFAULT_MODEL_ID = "eleven_multilingual_v2"
DEFAULT_OUTPUT_FORMAT = "mp3_44100_128"
DEFAULT_OUTPUT_DIR = Path("outputs/voiceovers")
DEFAULT_HOME_CONFIG = Path.home() / "local" / "elevenlabs" / "profiles.json"
PROJECT_CONFIG_PATHS = (
    Path("config/local/elevenlabs-tts.json"),
)


class ElevenLabsError(RuntimeError):
    pass


def parse_env_file(path: Path) -> dict[str, str]:
    values: dict[str, str] = {}
    if not path.exists():
        return values
    for raw_line in path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        key = key.strip()
        value = value.strip().strip('"').strip("'")
        if key:
            values[key] = value
    return values


def find_upward(start: Path, relative_path: Path) -> Optional[Path]:
    current = start.resolve()
    if current.is_file():
        current = current.parent
    for folder in [current, *current.parents]:
        candidate = folder / relative_path
        if candidate.exists():
            return candidate
        if folder == Path.home():
            break
    return None


def find_env_file(start: Path) -> Optional[Path]:
    return find_upward(start, Path(".env"))


def load_env(env_file: Optional[str]) -> dict[str, str]:
    values = dict(os.environ)
    candidate = Path(env_file).expanduser() if env_file else find_env_file(Path.cwd())
    if candidate:
        for key, value in parse_env_file(candidate).items():
            values.setdefault(key, value)
    return values


def resolve_config_path(args_config: Optional[str], env: dict[str, str]) -> Optional[Path]:
    explicit = args_config or env.get("ELEVENLABS_TTS_CONFIG")
    if explicit:
        return Path(explicit).expanduser()
    for relative_path in PROJECT_CONFIG_PATHS:
        candidate = find_upward(Path.cwd(), relative_path)
        if candidate:
            return candidate
    if DEFAULT_HOME_CONFIG.exists():
        return DEFAULT_HOME_CONFIG
    return None


def load_config(path: Optional[Path]) -> tuple[dict[str, Any], Optional[Path]]:
    if not path:
        return {}, None
    if not path.exists():
        raise ElevenLabsError(f"Config file not found: {path}")
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as error:
        raise ElevenLabsError(f"Invalid JSON in config file {path}: {error}") from error
    if not isinstance(data, dict):
        raise ElevenLabsError(f"Config file must contain a JSON object: {path}")
    return data, path


def select_profile(config: dict[str, Any], profile_name: Optional[str]) -> tuple[dict[str, Any], Optional[str]]:
    profiles = config.get("profiles")
    if profiles is None:
        return config, profile_name
    if not isinstance(profiles, dict):
        raise ElevenLabsError("Config field 'profiles' must be an object.")
    selected_name = profile_name or config.get("default_profile")
    if not selected_name:
        if len(profiles) == 1:
            selected_name = next(iter(profiles))
        else:
            available = ", ".join(sorted(profiles))
            raise ElevenLabsError(f"Select a profile with --profile. Available profiles: {available}")
    profile = profiles.get(selected_name)
    if not isinstance(profile, dict):
        available = ", ".join(sorted(profiles))
        raise ElevenLabsError(f"Profile '{selected_name}' not found. Available profiles: {available}")
    return profile, str(selected_name)


def api_json(path: str, api_key: str, params: Optional[dict[str, Any]] = None) -> dict[str, Any]:
    query = f"?{urlencode(params)}" if params else ""
    request = Request(
        f"{API_BASE}{path}{query}",
        headers={"xi-api-key": api_key, "Accept": "application/json"},
        method="GET",
    )
    with open_request(request) as response:
        return json.loads(response.read().decode("utf-8"))


def api_audio(path: str, api_key: str, payload: dict[str, Any], params: dict[str, Any]) -> bytes:
    request = Request(
        f"{API_BASE}{path}?{urlencode(params)}",
        data=json.dumps(payload).encode("utf-8"),
        headers={
            "xi-api-key": api_key,
            "Content-Type": "application/json",
            "Accept": "audio/mpeg",
        },
        method="POST",
    )
    with open_request(request) as response:
        return response.read()


def open_request(request: Request):
    try:
        return urlopen(request, timeout=90)
    except HTTPError as error:
        detail = error.read().decode("utf-8", errors="replace")
        raise ElevenLabsError(f"ElevenLabs API returned {error.code}: {detail}") from error
    except URLError as error:
        raise ElevenLabsError(f"Could not reach ElevenLabs API: {error.reason}") from error


def resolve_voice_id(api_key: str, voice_name: str) -> tuple[str, dict[str, Any]]:
    data = api_json("/v2/voices", api_key, {"search": voice_name, "page_size": 100})
    voices = data.get("voices", [])
    exact = [voice for voice in voices if voice.get("name") == voice_name]
    if not exact:
        names = ", ".join(sorted(str(voice.get("name", "")) for voice in voices if voice.get("name")))
        suffix = f" Matches returned: {names}" if names else " No matching voices returned."
        raise ElevenLabsError(f"Could not find an ElevenLabs voice named '{voice_name}'.{suffix}")
    if len(exact) > 1:
        ids = ", ".join(str(voice.get("voice_id")) for voice in exact)
        raise ElevenLabsError(f"Found multiple voices named '{voice_name}'. Set voice_id to one of: {ids}")
    voice = exact[0]
    voice_id = voice.get("voice_id")
    if not voice_id:
        raise ElevenLabsError(f"Voice '{voice_name}' did not include a voice_id in the API response.")
    return str(voice_id), voice


def read_text(args: argparse.Namespace) -> str:
    if args.text:
        text = args.text
    elif args.text_file:
        text = Path(args.text_file).expanduser().read_text(encoding="utf-8")
    elif not sys.stdin.isatty():
        text = sys.stdin.read()
    else:
        raise ElevenLabsError("Provide --text, --text-file, or pipe text through stdin.")
    text = text.strip()
    if not text:
        raise ElevenLabsError("Text is empty.")
    return text


def slugify(value: Optional[str]) -> str:
    if not value:
        return "elevenlabs-voice"
    slug = re.sub(r"[^a-zA-Z0-9]+", "-", value.strip().lower()).strip("-")
    return slug or "elevenlabs-voice"


def default_output_path(output_dir: Path, profile_name: Optional[str], voice_name: Optional[str]) -> Path:
    stamp = dt.datetime.now().strftime("%Y%m%d-%H%M%S")
    label = slugify(profile_name or voice_name)
    return output_dir / f"{label}-{stamp}.mp3"


def parse_settings_json(value: Optional[str]) -> dict[str, Any]:
    if not value:
        return {}
    try:
        parsed = json.loads(value)
    except json.JSONDecodeError as error:
        raise ElevenLabsError(f"--settings-json must be valid JSON: {error}") from error
    if not isinstance(parsed, dict):
        raise ElevenLabsError("--settings-json must decode to a JSON object.")
    return parsed


def profile_settings(profile: dict[str, Any], args: argparse.Namespace, env: dict[str, str]) -> dict[str, Any]:
    settings = profile.get("voice_settings") or {}
    if not isinstance(settings, dict):
        raise ElevenLabsError("Profile field 'voice_settings' must be an object.")
    merged = dict(settings)
    env_settings = parse_settings_json(env.get("ELEVENLABS_TTS_SETTINGS_JSON"))
    merged.update(env_settings)
    merged.update(parse_settings_json(args.settings_json))
    return merged


def choose_value(*values: Optional[str]) -> Optional[str]:
    for value in values:
        if value:
            return value
    return None


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Generate ElevenLabs speech from a local voice profile.")
    parser.add_argument("--text", help="Text to synthesize.")
    parser.add_argument("--text-file", help="UTF-8 text file to synthesize.")
    parser.add_argument("--output", help="Output audio path. Defaults to the selected profile output_dir.")
    parser.add_argument("--env-file", help="Path to a .env file. Defaults to nearest .env from the current directory.")
    parser.add_argument("--config", help="Path to a local ElevenLabs TTS profile JSON file.")
    parser.add_argument("--profile", help="Profile name inside the local config.")
    parser.add_argument("--voice-id", help="Explicit ElevenLabs voice id.")
    parser.add_argument("--voice-name", help="Voice name to search when no id is set.")
    parser.add_argument("--model-id", help=f"ElevenLabs model id. Defaults to profile value, then {DEFAULT_MODEL_ID}.")
    parser.add_argument("--output-format", help=f"Output format. Defaults to profile value, then {DEFAULT_OUTPUT_FORMAT}.")
    parser.add_argument("--settings-json", help="JSON object of voice_settings overrides for this generation.")
    parser.add_argument("--seed", type=int, help="Optional ElevenLabs seed for best-effort repeatability.")
    parser.add_argument("--dry-run", action="store_true", help="Print the resolved request payload without generating audio.")
    parser.add_argument("--list-voices", action="store_true", help="List voices matching the configured voice name and exit.")
    return parser


def main() -> int:
    args = build_parser().parse_args()
    env = load_env(args.env_file)
    api_key = env.get("ELEVENLABS_API_KEY")
    if not api_key:
        raise ElevenLabsError("Missing ELEVENLABS_API_KEY in the environment or nearest .env file.")

    config, config_path = load_config(resolve_config_path(args.config, env))
    env_profile = env.get("ELEVENLABS_TTS_PROFILE")
    profile, profile_name = select_profile(config, args.profile or env_profile)

    voice_id_env_name = profile.get("voice_id_env")
    voice_id_from_env = env.get(str(voice_id_env_name)) if voice_id_env_name else None
    voice_id = choose_value(args.voice_id, env.get("ELEVENLABS_TTS_VOICE_ID"), voice_id_from_env, profile.get("voice_id"))
    voice_name = choose_value(args.voice_name, env.get("ELEVENLABS_TTS_VOICE_NAME"), profile.get("voice_name"))
    model_id = choose_value(args.model_id, env.get("ELEVENLABS_TTS_MODEL_ID"), profile.get("model_id"), DEFAULT_MODEL_ID)
    output_format = choose_value(
        args.output_format,
        env.get("ELEVENLABS_TTS_OUTPUT_FORMAT"),
        profile.get("output_format"),
        DEFAULT_OUTPUT_FORMAT,
    )

    if args.list_voices:
        params: dict[str, Any] = {"page_size": 100}
        if voice_name:
            params["search"] = voice_name
        data = api_json("/v2/voices", api_key, params)
        for voice in data.get("voices", []):
            print(f"{voice.get('voice_id')}\t{voice.get('name')}")
        return 0

    if not voice_id and not voice_name:
        raise ElevenLabsError("Set voice_id or voice_name in local config, env, or CLI args.")

    resolved_voice: Optional[dict[str, Any]] = None
    if not voice_id and voice_name:
        voice_id, resolved_voice = resolve_voice_id(api_key, voice_name)

    text = read_text(args)
    payload: dict[str, Any] = {
        "text": text,
        "model_id": model_id,
    }
    settings = profile_settings(profile, args, env)
    if settings:
        payload["voice_settings"] = settings
    if args.seed is not None:
        payload["seed"] = args.seed

    profile_output_dir = profile.get("output_dir")
    output_dir = Path(str(profile_output_dir)).expanduser() if profile_output_dir else DEFAULT_OUTPUT_DIR
    output_path = Path(args.output).expanduser() if args.output else default_output_path(output_dir, profile_name, voice_name)
    if args.dry_run:
        print(json.dumps({
            "config_path": str(config_path) if config_path else None,
            "profile": profile_name,
            "voice_id": voice_id,
            "voice_name": voice_name,
            "resolved_voice_name": resolved_voice.get("name") if resolved_voice else None,
            "output": str(output_path),
            "output_format": output_format,
            "payload": payload,
        }, indent=2, sort_keys=True))
        return 0

    audio = api_audio(
        f"/v1/text-to-speech/{voice_id}",
        api_key,
        payload,
        {"output_format": output_format},
    )
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_bytes(audio)
    print(f"Wrote {output_path} ({len(audio)} bytes)")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except ElevenLabsError as error:
        print(f"error: {error}", file=sys.stderr)
        raise SystemExit(1)
