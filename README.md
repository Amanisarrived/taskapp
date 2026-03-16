# TaskHub Personal Task Tracker

A clean, professional Flutter app for managing personal tasks with Supabase authentication and database storage.

---

## 📱 Screens

| Screen | Description |
|--------|-------------|
| Login | Email/password login via Supabase Auth |
| Sign Up | New user registration with validation |
| Dashboard | View, add, edit, delete and complete tasks |

---

## ✨ Features

- Email/Password Authentication (Login, Signup, Logout)
- Protected routes — redirects to login if not authenticated
- Add tasks via bottom sheet
- Edit tasks inline
- Delete tasks with confirmation dialog + swipe to dismiss
- Mark tasks as completed (toggle)
- Tasks stored per user in Supabase with Row Level Security
- Shimmer loading effect
- Fade + slide animations on screens and task list
- Light/Dark theme toggle
- Reusable widget components
- Form validators with regex email check
- Unit tests for Task model serialization

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- A [Supabase](https://supabase.com) account (free tier works)
- Android Studio / VS Code with Flutter extension

### Installation

```bash
# 1. Clone the repo
git clone https://github.com/YOUR_USERNAME/task_app.git
cd task_app

# 2. Install dependencies
flutter pub get

# 3. Create .env file in project root (see Environment Setup below)

# 4. Run the app
flutter run
```

---

## 🔑 Environment Setup

This project uses `flutter_dotenv` to keep API keys secure and out of version control.

**Step 1** — Create a `.env` file in the project root:
```
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

**Step 2** — Get your keys from Supabase:
1. Open your Supabase project
2. Go to **Project Settings → API**
3. Copy **Project URL** and **anon/public** key
4. Paste them into your `.env` file

> ⚠️ Never commit your `.env` file. It is already listed in `.gitignore`.

---

## ⚙️ Supabase Setup

### Step 1 — Create a Supabase Project
1. Go to [https://supabase.com](https://supabase.com) and sign in
2. Click **New Project**, fill in name and password
3. Wait for the project to finish provisioning

### Step 2 — Disable Email Confirmation (for development)
1. Go to **Authentication → Settings**
2. Turn off **Enable email confirmations**

### Step 3 — Create the Tasks Table
Go to **SQL Editor** and run:

```sql
create table tasks (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  title text not null,
  is_completed boolean default false,
  created_at timestamp with time zone default now()
);

alter table tasks enable row level security;

create policy "Users can view own tasks"
  on tasks for select using (auth.uid() = user_id);

create policy "Users can insert own tasks"
  on tasks for insert with check (auth.uid() = user_id);

create policy "Users can update own tasks"
  on tasks for update using (auth.uid() = user_id);

create policy "Users can delete own tasks"
  on tasks for delete using (auth.uid() = user_id);
```

---

## 📂 Folder Structure

```
lib/
├── main.dart
├── app/
│   ├── constants.dart
│   └── theme.dart
├── auth/
│   ├── auth_service.dart
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   └── widget/
│       ├── input_label.dart
│       └── login_gradient_button.dart
├── dashboard/
│   ├── dashboard_screen.dart
│   ├── task_model.dart
│   ├── task_tile.dart
│   └── widgets/
│       ├── animated_task_item.dart
│       ├── dashboard_header.dart
│       ├── gradient_button.dart
│       ├── header_button.dart
│       ├── shimmer_loader.dart
│       ├── sliver_task_section.dart
│       ├── stat_card.dart
│       └── task_bottom_sheet.dart
├── provider/
│   └── task_provider.dart
├── services/
│   └── supabase_service.dart
└── utils/
    └── validators.dart

test/
└── task_model_test.dart
```

---

## 🧠 State Management

This app uses **Provider** for state management.

- `TaskProvider` holds the list of tasks and loading state
- `ThemeProvider` in `main.dart` manages light/dark theme switching
- `notifyListeners()` is called after every CRUD operation
- Auth state is handled via `Supabase.instance.client.auth.currentSession`

---

## 🧪 Running Tests

```bash
flutter test
```

Tests are in `test/task_model_test.dart` and cover:
- Task model `fromJson` deserialization
- Task model `toJson` serialization
- `copyWith` updates only specified fields
- Default `isCompleted` value is false

---

## 📸 Demo

> 🎥 [Watch Demo Video](YOUR_DEMO_LINK_HERE)

---

## 🛠️ Built With

- [Flutter](https://flutter.dev)
- [Supabase](https://supabase.com)
- [Provider](https://pub.dev/packages/provider)
- [flutter_dotenv](https://pub.dev/packages/flutter_dotenv)