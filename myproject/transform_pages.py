from pathlib import Path
import re

pages_dir = Path('main/template/pages')
backup_dir = pages_dir / 'backup_original'
backup_dir.mkdir(exist_ok=True)

for p in sorted([p for p in pages_dir.glob('*.html') if p.name not in {'layout.html', 'master.html'}]):
    text = p.read_text(encoding='utf-8')
    backup_path = backup_dir / p.name
    if not backup_path.exists():
        backup_path.write_text(text, encoding='utf-8')

    title_match = re.search(r'<title>(.*?)</title>', text, re.S | re.I)
    title = title_match.group(1).strip() if title_match else 'Poddar Tours & Travels'
    style_blocks = re.findall(r'<style[^>]*>(.*?)</style>', text, re.S | re.I)
    extra_css = '\n'.join(s.strip() for s in style_blocks if s.strip())
    body_match = re.search(r'<body[^>]*>(.*?)</body>', text, re.S | re.I)
    body = body_match.group(1).strip() if body_match else text

    body = re.sub(r'<div\s+id=["\']header["\']\s*>\s*</div>', '', body, flags=re.I)
    body = re.sub(r'<div\s+id=["\']footer["\']\s*>\s*</div>', '', body, flags=re.I)
    body = re.sub(r'<script[^>]*>.*?</script>', '', body, flags=re.I | re.S)
    body = re.sub(
        r'href=["\'](?!https?://|/|mailto:|tel:|#)([^"\']+\.html)["\']',
        lambda m: f'href="/{Path(m.group(1)).name}"',
        body,
    )
    body = re.sub(r'src=["\'](?:\.\./)*img/([^"\']+)["\']', r"src=\"{% static 'img/\1' %}\"", body)
    body = re.sub(r'src=["\'](?:\.\./)*css/([^"\']+)["\']', r"src=\"{% static 'css/\1' %}\"", body)
    body = re.sub(
        r'url\(\s*["\']?(?:\.\./)*img/([^"\')]+)["\']?\s*\)',
        r"url('{% static 'img/\1' %}')",
        body,
    )
    body = re.sub(r'<link[^>]+rel=["\']stylesheet["\'][^>]*>', '', body, flags=re.I)
    body = re.sub(r'<meta[^>]*>', '', body, flags=re.I)
    content = body.strip()
    content = re.sub(r'</?html[^>]*>', '', content, flags=re.I)
    content = re.sub(r'</?body[^>]*>', '', content, flags=re.I)
    content = content.strip()

    new_text = '{% extends "base.html" %}\n{% load static %}\n\n{% block title %}' + title + '{% endblock %}\n\n'
    if extra_css:
        new_text += '{% block extra_css %}\n<style>\n' + extra_css + '\n</style>\n{% endblock %}\n\n'
    new_text += '{% block content %}\n' + content + '\n{% endblock %}\n'
    p.write_text(new_text, encoding='utf-8')
    print(f'Converted {p.name}')
