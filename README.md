# Vocab App

Rails API と Vue/Vite フロントエンドで作られた単語学習アプリです。

## 構成

- `backend/`: Rails API
- `frontend/`: Vue 3 + Vite
- `docker-compose.yml`: PostgreSQL、バックエンド、フロントエンドをまとめて起動する設定

## 必要なもの

- Docker
- Docker Compose

## 起動方法

初回起動、または依存関係を更新した後はビルドして起動します。

```sh
docker compose up --build
```

2回目以降は次のコマンドで起動できます。

```sh
docker compose up
```

起動後、ブラウザで以下にアクセスします。

- フロントエンド: http://localhost:5174
- バックエンドAPI: http://localhost:3000

バックエンド起動時に `rails db:prepare` が実行されるため、データベース作成とマイグレーションは自動で行われます。

## 停止方法

```sh
docker compose down
```

データベースの内容も含めて削除したい場合は、Docker volume も削除します。

```sh
docker compose down -v
```

## テスト

バックエンドのテストを実行します。

```sh
docker compose exec backend bundle exec rails test
```

フロントエンドをビルド確認します。

```sh
docker compose exec frontend npm run build
```

## よく使うコマンド

Rails コンソールを開く:

```sh
docker compose exec backend bundle exec rails console
```

マイグレーションを実行する:

```sh
docker compose exec backend bundle exec rails db:migrate
```

フロントエンドの依存関係を追加する:

```sh
docker compose exec frontend npm install <package-name>
```

バックエンドの依存関係を追加した後にインストールする:

```sh
docker compose exec backend bundle install
```

## 環境変数

Docker Compose では以下の開発用設定を使っています。

- `DATABASE_HOST=db`
- `DATABASE_USER=postgres`
- `DATABASE_PASSWORD=password`
- `VITE_API_BASE_URL=http://localhost:3000`

必要に応じて `docker-compose.yml` を編集してください。
