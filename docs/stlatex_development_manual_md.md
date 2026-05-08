# StLaTeX 開発手順書

## 0. 目的

本ドキュメントは、StLaTeX の MVP を 4 人チームで開発するための実装手順書である。

対象：

- Claude Code を使って開発するメンバー
- Flutter / FastAPI / GCP 構成で開発するメンバー
- ハッカソン期間中に迅速に環境構築したいメンバー

---

# 1. MVPのゴール

まず完成させるべき体験は以下。

```text
模試結果を入力
↓
AIが学力と志望校傾向を分析
↓
優先単元と捨て単元を提案
↓
今週の受験戦略を生成
↓
ダッシュボードに表示
```

重要：

- 最初から全部作らない
- Gemini API は後から接続する
- まずはモックAIで完成まで持っていく

---

# 2. 開発環境

## 必要ソフトウェア

### 全員

- Git
- GitHub Desktop（任意）
- VSCode
- Claude Code

---

## Flutter担当

- Flutter SDK
- Android Studio
- Xcode（Macのみ）

確認：

```bash
flutter doctor
```

---

## Backend担当

- Python 3.11+
- uv または pip
- Docker

確認：

```bash
python --version
```

---

## GCP担当

- Google Cloud SDK
- Firebase CLI

確認：

```bash
gcloud --version
firebase --version
```

---

# 3. リポジトリ作成

## GitHub Repository

```text
stlatex
```

---

## Clone

```bash
git clone https://github.com/your-org/stlatex.git
cd stlatex
```

---

# 4. ディレクトリ構成

```text
stlatex/
  apps/
    mobile/
  services/
    api/
  docs/
  infra/
```

---

# 5. Claude Code へ最初に投げる内容

最初は AI 接続しない。

まず骨格だけ作る。

Claude Code へ以下を投げる。

```text
FutureMate / StLaTeX の MVP を作ります。

まず以下を実装してください。

- FastAPI バックエンド雛形
- Flutter アプリ雛形
- Firestore service 層
- StudyLog CRUD API
- mock_strategy.json を返す Strategy API
- Dashboard 画面
- Strategy 画面

Gemini API はまだ接続しないでください。
AI出力は固定JSONで返してください。
後から Gemini service に差し替え可能な構造にしてください。
```

---

# 6. Flutter セットアップ

## 作成

```bash
cd apps
flutter create mobile
```

---

## 起動確認

```bash
cd mobile
flutter run
```

---

## 推奨ライブラリ

```yaml
dependencies:
  flutter_riverpod:
  go_router:
  dio:
  firebase_core:
  firebase_auth:
  cloud_firestore:
  firebase_messaging:
  image_picker:
```

---

# 7. FastAPI セットアップ

## 作成

```bash
mkdir -p services/api
cd services/api
```

---

## 仮想環境

### uv 使用時

```bash
uv venv
source .venv/bin/activate
```

---

## インストール

```bash
pip install fastapi uvicorn python-dotenv firebase-admin google-cloud-firestore google-genai pillow
```

---

## 起動

```bash
uvicorn app.main:app --reload
```

---

# 8. FastAPI 推奨構成

```text
services/api/app/
  main.py
  routers/
  services/
  schemas/
  prompts/
```

---

# 9. Firestore Emulator を使う

クレジットが来る前は Emulator を使う。

---

## Emulator 起動

```bash
firebase emulators:start
```

---

## Firestore 接続

`.env`

```env
FIRESTORE_EMULATOR_HOST=localhost:8080
```

---

# 10. モックAIを先に作る

## mock_strategy.json

```json
{
  "mainGoal": "数学III 微積分を強化する",
  "prioritySubjects": ["math", "english"],
  "priorityUnits": [
    {
      "subject": "math",
      "unit": "微積分"
    }
  ],
  "discardUnits": [
    {
      "subject": "math",
      "unit": "整数"
    }
  ],
  "riskAlerts": [
    {
      "message": "英語学習量が減少しています"
    }
  ]
}
```

---

## Strategy API

```python
from fastapi import APIRouter
import json

router = APIRouter()

@router.get("/strategies/latest")
def get_strategy():
    with open("mock_strategy.json") as f:
        return json.load(f)
```

---

# 11. Flutter で API 表示

## Dio example

```dart
final response = await dio.get(
  'http://localhost:8000/strategies/latest',
);
```

---

## Dashboard に表示

表示項目：

- mainGoal
- prioritySubjects
- discardUnits
- riskAlerts

---

# 12. 役割分担

## AI担当

責務：

- Gemini
- Prompt
- 戦略生成
- JSON安定化

成果物：

- prompts/
- strategy_engine.py

---

## Backend担当

責務：

- FastAPI
- Firestore
- API
- Cloud Run

成果物：

- routers/
- services/
- schemas/

---

## Flutter担当

責務：

- UI
- Riverpod
- API連携

成果物：

- Dashboard
- StudyLogScreen
- StrategyScreen

---

## PM/デザイン担当

責務：

- UI統一
- 仕様管理
- デモ
- 発表資料

成果物：

- Figma
- 発表スライド

---

# 13. GCPクレジット到着後

ここから本番接続する。

---

# 14. GCP 初期設定

## プロジェクト作成

```bash
gcloud projects create stlatex
```

---

## Vertex AI 有効化

```bash
gcloud services enable aiplatform.googleapis.com
```

---

## Cloud Run 有効化

```bash
gcloud services enable run.googleapis.com
```

---

## Firestore 有効化

Firebase Console から Native Mode を有効化。

---

# 15. Gemini API 接続

## インストール

```bash
pip install google-genai
```

---

## .env

```env
GOOGLE_CLOUD_PROJECT=stlatex
GOOGLE_CLOUD_LOCATION=us-central1
GEMINI_MODEL=gemini-2.5-flash
```

---

## gemini_service.py

```python
from google import genai

client = genai.Client()

response = client.models.generate_content(
    model="gemini-2.5-flash",
    contents="hello"
)
```

---

# 16. Geminiで重要なこと

## JSON固定

必ず：

```text
JSON only.
Do not output markdown.
```

を入れる。

---

## AIを信用しすぎない

Gemini が壊れても fallback を返す。

例：

```python
try:
    strategy = generate_strategy()
except:
    strategy = fallback_strategy()
```

---

# 17. 模試OCR

最初は Vision AI を使わなくてよい。

Gemini Vision だけで十分。

---

## Flutter

```dart
final XFile? image = await picker.pickImage(
  source: ImageSource.gallery,
);
```

---

## Backend

画像アップロード
↓
Gemini Vision
↓
JSON抽出

---

# 18. Cloud Run デプロイ

## Docker build

```bash
docker build -t stlatex-api .
```

---

## Deploy

```bash
gcloud run deploy stlatex-api
```

---

# 19. MVP完成条件

最低限必要：

- Dashboard
- StudyLog
- 模試登録
- Strategy生成
- 捨て単元提案
- Gemini連携

---

# 20. デモで最重要なこと

## 「AIが考えてる感」を出す

重要：

❌ 普通の分析ツール

⭕ AIが意思決定してる

---

## 良いデモ例

```text
模試結果アップロード
↓
AI分析
↓
「数学IIIが間に合わない可能性があります」
↓
「整数問題は一旦優先度を下げてください」
↓
「英語長文へ時間投資した方が期待値が高いです」
```

---

# 21. 最後に

StLaTeX の価値は、
AIが問題を解説することではない。

## 「限られた時間の中で、何に時間投資すべきかを意思決定すること」

が本質である。

そのため、実装では以下を最優先する。

- 過去問傾向
- 学習ログ
- 捨て単元提案
- 合格期待値最適化
- 週間戦略生成

ここが動けば、MVPとして十分強い。

