# StLaTeX Claude Code向け実装設計書 v2

## 0. この設計書の目的

このドキュメントは、Claude Code を使って StLaTeX を実装するための実装設計書である。

Claude Code が迷わず段階的に実装できるように、以下を明確にする。

- プロダクトの実装方針
- MVPの完成条件
- リポジトリ構成
- docs / skills / CLAUDE.md の役割分担
- Flutter / FastAPI / Firestore の責務
- mock-first 開発手順
- Gemini への差し替え方針
- API設計
- Firestore設計
- Claude Code への依頼順序

---

# 1. プロダクト概要

## プロダクト名

StLaTeX

読み：すとらてふ

## GitHub Description

AI-powered strategic tutoring agent that maximizes university entrance exam success probability through long-term learning analysis, past exam trend optimization, and dynamic study strategy generation.

## コンセプト

StLaTeX は、大学受験生の学習ログ・模試結果・志望校過去問傾向・残り日数を分析し、合格期待値を最大化する受験戦略AIエージェントである。

単なるAI家庭教師ではない。

StLaTeX の中心価値は、以下の意思決定をAIが支援することにある。

- 何を優先するか
- 何を後回しにするか
- どの単元を一旦捨てるか
- どの科目に時間投資するか
- 今週の勉強戦略をどう変えるか

---

# 2. 最重要方針

## 2-1. AIから作らない

最初から Gemini を接続しない。

最初は固定JSONを返す mock strategy API で、以下の体験を完成させる。

```text
入力
↓
分析結果表示
↓
戦略提案
↓
捨て単元提示
↓
Dashboard反映
```

Gemini は、UI・API・schema が安定してから差し替える。

---

## 2-2. mock-first architecture

最初に作るべきもの：

- Flutter UI
- FastAPI API
- Firestore schema
- mock_strategy.json
- Dashboard 表示

後から作るもの：

- Gemini strategy engine
- 模試OCR
- FCM通知
- Cloud Run本番運用

---

## 2-3. 作りすぎない

MVPでは以下を作り込まない。

- 問題解説AI
- 問題生成AI
- SNS機能
- 高度な独自MLモデル
- 複雑なゲーミフィケーション
- 完全自動OCR
- 高精度な合格確率予測

---

# 3. CLAUDE.md / docs / skills の役割

## 3-1. CLAUDE.md

CLAUDE.md には共通ルールだけを書く。

入れるもの：

- プロジェクト全体方針
- PR法
- ファイル編集ポリシー
- mock-first 方針
- MVP優先順位
- デモ優先方針
- 実装哲学

入れないもの：

- Flutter詳細
- FastAPI詳細
- Firestore詳細
- Geminiプロンプト詳細
- Cloud Run手順
- OCR詳細

---

## 3-2. docs/

人間と Claude Code の両方が読む設計資料を置く。

推奨：

```text
docs/
  product_spec.md
  development_manual.md
  claude_code_design.md
  api_spec.md
  firestore_schema.md
  prompt_design.md
  architecture.md
  demo_script.md
  pitch.md
```

---

## 3-3. skills/

Claude Code 用の専門知識を分離する。

推奨：

```text
skills/
  flutter_skill.md
  fastapi_skill.md
  firestore_skill.md
  gemini_prompt_skill.md
  cloudrun_skill.md
  ui_design_skill.md
  strategy_engine_skill.md
```

各 skill には、その領域だけの実装ルールを書く。

---

# 4. 技術スタック

## Frontend

- Flutter
- Dart
- Riverpod
- go_router
- Dio

## Backend

- FastAPI
- Python 3.11+
- Pydantic
- Uvicorn

## Database

- Firestore
- 開発初期は Firestore Emulator

## AI

- Vertex AI Gemini
- Gemini 2.5 Flash 系を基本にする

## Image / OCR

MVP初期：手動入力

MVP後半：Gemini Vision または Vision AI

## Deploy

- Cloud Run
- Firebase Hosting は使わない想定

---

# 5. 推奨リポジトリ構成

```text
stlatex/
  README.md
  CLAUDE.md
  .gitignore
  .env.example

  docs/
    product_spec.md
    development_manual.md
    claude_code_design.md
    api_spec.md
    firestore_schema.md
    prompt_design.md
    architecture.md
    demo_script.md
    pitch.md

  skills/
    flutter_skill.md
    fastapi_skill.md
    firestore_skill.md
    gemini_prompt_skill.md
    cloudrun_skill.md
    ui_design_skill.md
    strategy_engine_skill.md

  apps/
    mobile/
      lib/
        main.dart
        app.dart
        core/
          constants/
          theme/
          utils/
          routing/
        features/
          onboarding/
          dashboard/
          study_log/
          mock_exam/
          strategy/
          past_exam/
          interview/
          settings/
        shared/
          widgets/
          models/
          services/
      pubspec.yaml

  services/
    api/
      app/
        main.py
        config.py
        routers/
          health.py
          users.py
          study_logs.py
          mock_exams.py
          strategies.py
          past_exams.py
        services/
          firestore_service.py
          mock_strategy_service.py
          strategy_engine.py
          gemini_service.py
          risk_detector.py
          past_exam_analyzer.py
        schemas/
          user.py
          study_log.py
          mock_exam.py
          strategy.py
          past_exam.py
        prompts/
          strategy_system.md
          strategy_generation.md
          discard_unit.md
          past_exam_analysis.md
        mocks/
          mock_strategy.json
        tests/
      requirements.txt
      Dockerfile
      README.md

  infra/
    firestore.rules
    firestore.indexes.json
    cloudrun.yaml
```

---

# 6. MVP完成条件

MVPで必ず動かすもの：

1. Flutterアプリが起動する
2. Dashboard が表示される
3. Study Log を入力できる
4. Mock Exam を手動入力できる
5. FastAPI が起動する
6. `/strategies/latest` が mock strategy を返す
7. Flutter が API から strategy を取得して表示する
8. 優先単元と捨て単元が見える
9. AI reasoning summary が見える
10. Gemini接続前でもデモが成立する

---

# 7. 実装フェーズ

## Phase 1: Repository Bootstrap

目的：プロジェクトの骨格を作る。

実装：

- README.md
- CLAUDE.md
- docs/
- skills/
- apps/mobile/
- services/api/
- infra/
- .env.example

この時点では中身は最小でよい。

---

## Phase 2: Backend Mock API

目的：Flutterから取得できるAPIを作る。

実装：

- FastAPI初期化
- health check
- mock_strategy.json
- `/strategies/latest`
- `/study-logs`
- `/mock-exams`

Geminiは接続しない。

---

## Phase 3: Flutter Mock UI

目的：アプリ体験を先に完成させる。

実装画面：

- OnboardingScreen
- DashboardScreen
- StudyLogScreen
- MockExamScreen
- StrategyScreen

Dashboard では mock strategy を表示する。

---

## Phase 4: Firestore Emulator

目的：ローカルDBでデータ保存できる状態にする。

実装：

- Firestore Emulator設定
- firestore_service.py
- studyLogs 保存
- mockExams 保存
- strategies 保存

---

## Phase 5: Strategy Engine Mock Logic

目的：固定JSONではなく、入力に応じた簡易戦略を返す。

実装：

- 苦手科目優先
- 志望校頻出単元優先
- 低頻度・高難度単元を後回し
- 睡眠不足なら詰め込み警告

この段階ではルールベースでよい。

---

## Phase 6: Gemini Integration

目的：mock strategy を Gemini strategy generation に置き換える。

実装：

- gemini_service.py
- prompt files
- JSON parse
- fallback_strategy
- error handling

Gemini失敗時は必ず mock / fallback を返す。

---

## Phase 7: Demo Polish

目的：ハッカソン発表で刺さる状態にする。

実装：

- デモデータ
- Dashboard改善
- reasoning 表示
- 捨て単元カード
- 戦略変更のBefore/After
- demo_script.md

---

# 8. API設計

## GET /health

疎通確認。

Response:

```json
{
  "status": "ok"
}
```

---

## POST /users/me/onboarding

初期プロフィール登録。

Request:

```json
{
  "grade": "ronin",
  "targetUniversity": "東北大学",
  "targetFaculty": "工学部",
  "examType": "common_test_plus_secondary",
  "strongSubjects": ["english"],
  "weakSubjects": ["math", "chemistry"],
  "averageStudyHoursPerDay": 6,
  "remainingDays": 180
}
```

---

## POST /study-logs

学習ログ登録。

Request:

```json
{
  "date": "2026-05-08",
  "subject": "math",
  "unit": "微積分",
  "studyMinutes": 120,
  "accuracyRate": 0.72,
  "material": "青チャート",
  "memo": "計算ミスが多い",
  "mood": "normal",
  "sleepHours": 6
}
```

---

## GET /study-logs/recent

直近ログ取得。

Query:

```text
limit=14
```

---

## POST /mock-exams

模試結果の手動登録。

Request:

```json
{
  "examName": "第1回全統記述模試",
  "examDate": "2026-05-01",
  "scores": {
    "english": 132,
    "math": 105,
    "physics": 68,
    "chemistry": 61
  },
  "deviations": {
    "english": 61.2,
    "math": 54.8,
    "physics": 57.4,
    "chemistry": 52.1
  },
  "judgement": "C"
}
```

---

## GET /strategies/latest

最新戦略取得。

初期は mock_strategy.json を返す。

---

## POST /strategies/generate

戦略生成。

初期：ルールベース

後半：Gemini

Response:

```json
{
  "mainGoal": "数学III 微積分を重点強化する",
  "prioritySubjects": ["math", "english"],
  "priorityUnits": [
    {
      "subject": "math",
      "unit": "微積分",
      "reason": "志望校頻出かつ現在の正答率が低いため",
      "recommendedMinutes": 420
    }
  ],
  "discardUnits": [
    {
      "subject": "math",
      "unit": "整数",
      "reason": "頻度が低く、短期得点期待値が低いため",
      "risk": "出題された場合に失点リスクあり",
      "reviewTiming": "7月以降に再評価"
    }
  ],
  "riskAlerts": [
    {
      "type": "pace_delay",
      "message": "化学の学習量が2週間連続で不足しています",
      "severity": "medium"
    }
  ],
  "weeklyPlan": [
    {
      "day": "Monday",
      "tasks": ["数学 微積分 90分", "英語 長文 60分"]
    }
  ],
  "aiReasoningSummary": "数学の微積分は志望校頻出かつ現在の正答率が低いため、今週の最優先に設定しました。"
}
```

---

# 9. Firestore設計

詳細は `docs/firestore_schema.md` に分離する。

この設計書では主要collectionだけ定義する。

```text
users/{userId}
users/{userId}/studyLogs/{logId}
users/{userId}/mockExams/{mockExamId}
users/{userId}/strategies/{strategyId}
universities/{universityId}
universities/{universityId}/pastExamTrends/{trendId}
```

---

# 10. Flutter画面責務

## DashboardScreen

最重要画面。

表示：

- 今週のmainGoal
- 優先科目
- 優先単元
- 捨て単元
- riskAlerts
- aiReasoningSummary

---

## StudyLogScreen

学習ログ入力。

---

## MockExamScreen

模試結果入力。

初期は手動入力。

---

## StrategyScreen

詳細戦略表示。

表示：

- weeklyPlan
- discardUnits
- priorityUnits
- reasoning

---

## PastExamScreen

MVP後半。

志望校過去問傾向を表示。

---

# 11. AI設計

詳細は `skills/gemini_prompt_skill.md` と `skills/strategy_engine_skill.md` に分離する。

ここでは高レベル方針だけ定義する。

## AIの役割

AIは問題解説者ではなく、受験戦略エージェントである。

常に以下を考える。

```text
この受験生は今、何に時間を使うべきか？
何を今週は後回しにすべきか？
```

## 出力制約

- JSON only
- Markdown禁止
- 断定しすぎない
- 不安を煽りすぎない
- 捨て単元は「完全に捨てる」ではなく「今週は優先度を下げる」表現にする
- 失敗時は fallback を返す

---

# 12. mock_strategy.json

初期実装では以下を配置する。

Path:

```text
services/api/app/mocks/mock_strategy.json
```

Content:

```json
{
  "mainGoal": "数学III 微積分を重点強化する",
  "prioritySubjects": ["math", "english"],
  "priorityUnits": [
    {
      "subject": "math",
      "unit": "微積分",
      "reason": "志望校頻出かつ現在の正答率が低いため",
      "recommendedMinutes": 420
    }
  ],
  "discardUnits": [
    {
      "subject": "math",
      "unit": "整数",
      "reason": "頻度が低く、短期得点期待値が低いため",
      "risk": "出題された場合に失点リスクあり",
      "reviewTiming": "7月以降に再評価"
    }
  ],
  "riskAlerts": [
    {
      "type": "pace_delay",
      "message": "化学の学習量が2週間連続で不足しています",
      "severity": "medium"
    }
  ],
  "weeklyPlan": [
    {
      "day": "Monday",
      "tasks": ["数学 微積分 90分", "英語 長文 60分"]
    }
  ],
  "aiReasoningSummary": "数学IIIの微積分は志望校で頻出かつ現在の正答率が低いため、今週の最優先に設定しました。一方、整数は頻度が低く短期改善コストが高いため、今週は優先度を下げます。"
}
```

---

# 13. Claude Codeへの依頼順序

## Step 1: repository bootstrap

```text
StLaTeX のリポジトリ骨格を作ってください。

- README.md
- CLAUDE.md
- docs/
- skills/
- apps/mobile/
- services/api/
- infra/
- .env.example

中身は最小でよいです。
まだGeminiは接続しないでください。
```

---

## Step 2: backend mock API

```text
services/api に FastAPI を実装してください。

必要なAPI:
- GET /health
- GET /strategies/latest
- POST /study-logs
- GET /study-logs/recent
- POST /mock-exams

/strategies/latest は services/api/app/mocks/mock_strategy.json を返してください。
Geminiはまだ使わないでください。
```

---

## Step 3: Flutter mock UI

```text
apps/mobile に Flutter UI を実装してください。

必要画面:
- DashboardScreen
- StudyLogScreen
- MockExamScreen
- StrategyScreen

DashboardScreen は FastAPI の /strategies/latest から取得した mock strategy を表示してください。
```

---

## Step 4: Firestore Emulator

```text
Firestore Emulator を使って StudyLog, MockExam, Strategy を保存できるようにしてください。
Firestore service 層を作り、router から直接Firestoreを触らない構成にしてください。
```

---

## Step 5: strategy rule engine

```text
Geminiを使わず、ルールベースで strategy を生成する strategy_engine.py を実装してください。

入力:
- user profile
- recent study logs
- mock exams
- past exam trends

出力:
- mainGoal
- prioritySubjects
- priorityUnits
- discardUnits
- riskAlerts
- weeklyPlan
- aiReasoningSummary

まずは単純なルールで十分です。
```

---

## Step 6: Gemini integration

```text
mock / rule-based strategy_engine.py を Gemini 対応に拡張してください。

要件:
- Vertex AI Geminiを使う
- JSON onlyで出力させる
- JSON parseに失敗したらfallbackを返す
- promptは app/prompts/ に分離する
- gemini_service.py にAPI呼び出しを集約する
```

---

# 14. チーム担当

## AI Engineer

担当：

- strategy_engine.py
- gemini_service.py
- prompts/
- fallback strategy
- JSON安定化

---

## Backend Engineer

担当：

- FastAPI
- Firestore
- API設計
- Cloud Run
- Emulator

---

## Flutter Engineer

担当：

- Dashboard
- StudyLog
- MockExam
- Strategy
- API Client

---

## PM / Designer

担当：

- docs整理
- demo_script
- pitch
- UI確認
- 審査基準との対応整理

---

# 15. デモで見せる流れ

```text
1. 受験生プロフィールを見る
2. 模試結果を入力する
3. 学習ログを入力する
4. AI戦略生成を実行する
5. Dashboardに戦略が表示される
6. 優先単元が表示される
7. 捨て単元が表示される
8. reasoning summaryで理由を説明する
```

デモの肝：

```text
AIが「全部やれ」ではなく、「今はこれを優先し、これは後回し」と判断すること。
```

---

# 16. 実装時の注意

## 16-1. 捨て単元の表現

NG:

```text
この単元は捨ててください。
```

OK:

```text
今週は優先度を下げ、7月以降に再評価します。
```

---

## 16-2. 合格可能性の表現

NG:

```text
このままだと落ちます。
```

OK:

```text
現在の傾向では、数学IIIの対策遅れがリスクになっています。
```

---

## 16-3. AI失敗時

Geminiが失敗しても画面を壊さない。

必ず fallback を返す。

---

# 17. 最初に完成させるべき画面

最優先は Dashboard。

理由：

- デモの中心
- プロダクト価値が一目で伝わる
- AIエージェント感を出しやすい

Dashboard に最低限表示するもの：

- 今週の目標
- 優先単元
- 捨て単元
- リスク警告
- AIの判断理由

---

# 18. 最終原則

StLaTeX の価値は、AIが問題を解説することではない。

```text
限られた時間で、何に時間を使うべきかをAIが意思決定すること
```

が本質である。

実装では常にこの体験を最優先する。

