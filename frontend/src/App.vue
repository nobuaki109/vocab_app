<script setup>
import { ref, computed, onMounted } from "vue";
import WordList from "./components/words/WordList.vue";
import WordForm from "./components/words/WordForm.vue";
import WordQuiz from "./components/quiz/WordQuiz.vue";
import Wordwrong from "./components/quiz/Wordwrong.vue";
import { API_BASE_URL } from "./config/api.js";
const words = ref([]);
const english = ref("");
const japanese = ref("");
const exampleSentence = ref("");
const phonetic = ref("");
const audioUrl = ref("");
const title = ref("単語一覧アプリ");
const searchKeyword = ref("");
const isLookingUpWord = ref(false);
const errors = ref([]);
const editingWordId = ref(null);
const activeTab = ref("form");
const tabs = [
  { id: "form", label: "登録" },
  { id: "list", label: "一覧" },
  { id: "quiz", label: "クイズ" },
];
const formErrors = ref({
  english: "",
  japanese: "",
});
onMounted(async () => {
  const response = await fetch(`${API_BASE_URL}/words`);
  const data = await response.json();
  words.value = data;
});

const lookupWord = async () => {
  errors.value = [];
  formErrors.value = { english: "", japanese: "" };

  if (!english.value.trim()) {
    formErrors.value.english = "検索する英単語を入力して下さい。";
    return;
  }

  isLookingUpWord.value = true;
  const response = await fetch(
    `${API_BASE_URL}/words/lookup?english=${encodeURIComponent(english.value)}`,
  );

  isLookingUpWord.value = false;
  if (!response.ok) {
    const errorData = await response.json();
    errors.value = errorData.errors || ["単語情報の取得に失敗しました"];
    return;
  }

  const data = await response.json();
  english.value = data.english;
  japanese.value = data.japanese;
  exampleSentence.value = data.example_sentence;
  phonetic.value = data.phonetic;
  audioUrl.value = data.audio_url;
};

const validateWordForm = () => {
  formErrors.value = {
    english: "",
    japanese: "",
  };
  if (!english.value.trim()) {
    formErrors.value.english = "英単語を入力して下さい";
  }
  if (!japanese.value.trim()) {
    formErrors.value.japanese = "日本語を入力して下さい";
  }
  return !formErrors.value.english && !formErrors.value.japanese;
};

const createWord = async () => {
  errors.value = [];

  if (!validateWordForm()) {
    return;
  }

  const response = await fetch(`${API_BASE_URL}/words`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      word: {
        english: english.value,
        japanese: japanese.value,
        example_sentence: exampleSentence.value,
        phonetic: phonetic.value,
        audio_url: audioUrl.value,
      },
    }),
  });
  if (!response.ok) {
    const errorData = await response.json();
    errors.value = errorData.errors;
    return;
  }
  const result = await response.json();
  alert("送信完了！");
  words.value.unshift(result);
  resetForm();
  activeTab.value = "list";
};
const destroyWord = async (id) => {
  const confirmed = confirm("この単語を削除しますか？");
  if (!confirmed) {
    return;
  }
  const response = await fetch(`${API_BASE_URL}/words/${id}`, {
    method: "DELETE",
  });
  if (!response.ok) {
    alert("削除に失敗しました");
    return;
  }
  words.value = words.value.filter((word) => word.id != id);
};
const startEdit = (word) => {
  editingWordId.value = word.id;
  english.value = word.english;
  japanese.value = word.japanese;
  exampleSentence.value = word.example_sentence;
  activeTab.value = "form";
  phonetic.value = word.phonetic || "";
  audioUrl.value = word.audio_url || "";
};
const updateWord = async () => {
  errors.value = [];

  if (!validateWordForm()) {
    return;
  }
  const response = await fetch(`${API_BASE_URL}/words/${editingWordId.value}`, {
    method: "PATCH",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      word: {
        english: english.value,
        japanese: japanese.value,
        example_sentence: exampleSentence.value,
        phonetic: phonetic.value,
        audio_url: audioUrl.value,
      },
    }),
  });
  if (!response.ok) {
    const errorData = await response.json();
    errors.value = errorData.errors;
    return;
  }
  const updatedWord = await response.json();
  words.value = words.value.map((word) => {
    if (word.id === updatedWord.id) {
      return updatedWord;
    }
    return word;
  });
  resetForm();
  activeTab.value = "list";
};
const filteredWords = computed(() => {
  const keyword = searchKeyword.value.trim().toLowerCase();
  if (!keyword) {
    return words.value;
  }

  return words.value.filter((word) => {
    return (
      word.english.toLowerCase().includes(keyword) ||
      word.japanese.toLowerCase().includes(keyword)
    );
  });
});

const resetForm = () => {
  editingWordId.value = null;
  english.value = "";
  japanese.value = "";
  exampleSentence.value = "";
  phonetic.value = "";
  audioUrl.value = "";
  errors.value = [];
  formErrors.value = {
    english: "",
    japanese: "",
  };
};
const cancelEdit = () => {
  resetForm();
};
</script>
<template>
  <main class="app-shell">
    <!-- PC用サイドバー -->
    <aside class="app-sidebar">
      <div class="sidebar-brand">
        <p class="eyebrow">Vocabulary Notebook</p>
        <h1>{{ title }}</h1>
      </div>
      <div class="summary">
        <span class="summary-number">{{ words.length }}</span>
        <span class="summary-label">登録単語</span>
      </div>
      <nav class="sidebar-nav" aria-label="メインナビゲーション">
        <button
          v-for="tab in tabs"
          :key="tab.id"
          class="nav-button"
          :class="{ active: activeTab === tab.id }"
          @click="activeTab = tab.id"
        >
          {{ tab.label }}
        </button>
      </nav>
    </aside>

    <div class="app-main">
      <ul v-if="errors.length > 0" class="error-list">
        <li v-for="error in errors" :key="error">
          {{ error }}
        </li>
      </ul>
      <section class="workspace">
        <WordForm
          v-if="activeTab === 'form'"
          :english="english"
          :japanese="japanese"
          :example-sentence="exampleSentence"
          :is-editing="!!editingWordId"
          :form-errors="formErrors"
          :is-looking-up-word="isLookingUpWord"
          :phonetic="phonetic"
          :audio-url="audioUrl"
          @update:english="english = $event"
          @update:japanese="japanese = $event"
          @update:example-sentence="exampleSentence = $event"
          @submit-word="editingWordId ? updateWord() : createWord()"
          @cancel-edit="cancelEdit"
          @reset-form="resetForm"
          @lookup-word="lookupWord"
        />
        <WordList
          v-if="activeTab === 'list'"
          :words="filteredWords"
          :search-keyword="searchKeyword"
          @update:search-keyword="searchKeyword = $event"
          @delete-word="destroyWord"
          @edit-word="startEdit"
        />
        <div v-if="activeTab === 'quiz'" class="quiz-stack">
          <WordQuiz />
          <Wordwrong />
        </div>
      </section>
    </div>
  </main>
</template>

<style>
:root {
  color: #37352f;
  background: #ffffff;
  font-family:
    Inter,
    ui-sans-serif,
    system-ui,
    -apple-system,
    BlinkMacSystemFont,
    "Segoe UI",
    sans-serif;
  font-synthesis: none;
  line-height: 1.55;
  text-rendering: optimizeLegibility;
  --color-text: #37352f;
  --color-muted: #787774;
  --color-faint: #9b9a97;
  --color-canvas: #ffffff;
  --color-sidebar: #f7f7f5;
  --color-hover: #efefed;
  --color-active: #e8e8e5;
  --color-border: #e9e9e7;
  --color-border-strong: #d3d3d0;
  --color-danger: #d44c47;
  --color-danger-bg: #fdebec;
  --color-success: #0f7b6c;
  --color-success-bg: #dbeddb;
}

* {
  box-sizing: border-box;
}

body {
  margin: 0;
  min-width: 320px;
  min-height: 100vh;
  color: var(--color-text);
  background: var(--color-canvas);
}

button,
input,
textarea,
select {
  font: inherit;
}

button {
  border: 0;
  cursor: pointer;
}

button:focus-visible,
input:focus-visible,
textarea:focus-visible,
select:focus-visible {
  outline: 2px solid rgba(35, 131, 226, 0.35);
  outline-offset: 1px;
}

.app-shell {
  display: grid;
  grid-template-columns: 248px minmax(0, 1fr);
  min-height: 100vh;
}

.app-sidebar {
  position: sticky;
  top: 0;
  display: flex;
  flex-direction: column;
  align-self: start;
  width: 248px;
  height: 100vh;
  padding: 24px 14px;
  border-right: 1px solid var(--color-border);
  background: var(--color-sidebar);
}

.sidebar-brand {
  padding: 4px 10px 20px;
}

.eyebrow {
  margin: 0 0 6px;
  color: var(--color-muted);
  font-size: 0.68rem;
  font-weight: 600;
  letter-spacing: 0.06em;
  text-transform: uppercase;
}

h1 {
  margin: 0;
  color: var(--color-text);
  font-size: 1.08rem;
  font-weight: 650;
  line-height: 1.35;
}

.summary {
  display: flex;
  align-items: baseline;
  gap: 8px;
  margin: 0 4px 18px;
  padding: 10px;
  border-top: 1px solid var(--color-border);
  border-bottom: 1px solid var(--color-border);
}

.summary-number {
  color: var(--color-text);
  font-size: 1.35rem;
  font-weight: 650;
  line-height: 1;
}

.summary-label {
  color: var(--color-muted);
  font-size: 0.78rem;
  font-weight: 500;
}

.sidebar-nav {
  display: grid;
  gap: 2px;
}

.nav-button {
  width: 100%;
  min-height: 36px;
  padding: 0 10px;
  border-radius: 5px;
  color: var(--color-text);
  background: transparent;
  font-size: 0.9rem;
  font-weight: 500;
  text-align: left;
  transition: background-color 120ms ease;
}

.nav-button:hover {
  background: var(--color-hover);
}

.nav-button.active {
  background: var(--color-active);
  font-weight: 650;
}

.app-main {
  min-width: 0;
  padding: 52px clamp(32px, 6vw, 88px) 72px;
}

.error-list {
  width: min(100%, 920px);
  margin: 0 auto 20px;
  padding: 14px 18px 14px 36px;
  border: 1px solid #f1c1bf;
  border-radius: 5px;
  color: var(--color-danger);
  background: var(--color-danger-bg);
  font-size: 0.9rem;
}

.workspace {
  display: block;
  width: min(100%, 920px);
  margin: 0 auto;
}

.quiz-stack {
  display: grid;
  gap: 20px;
}

.panel {
  padding: 28px;
  border: 1px solid var(--color-border);
  border-radius: 6px;
  background: var(--color-canvas);
}

.panel-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 24px;
}

.panel-title {
  margin: 0;
  color: var(--color-text);
  font-size: 1.25rem;
  font-weight: 650;
  line-height: 1.35;
}

.panel-subtitle {
  margin: 5px 0 0;
  color: var(--color-muted);
  font-size: 0.9rem;
}

.button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-height: 36px;
  padding: 0 14px;
  border: 1px solid var(--color-text);
  border-radius: 5px;
  color: #ffffff;
  background: var(--color-text);
  font-size: 0.88rem;
  font-weight: 600;
  transition: background-color 120ms ease;
}

.button:hover {
  background: #2f2d29;
}

.button.secondary {
  color: var(--color-text);
  border-color: var(--color-border-strong);
  background: var(--color-canvas);
}

.button.secondary:hover {
  background: var(--color-hover);
}

.button.danger {
  color: var(--color-danger);
  border-color: #f1c1bf;
  background: var(--color-canvas);
}

.button.danger:hover {
  background: var(--color-danger-bg);
}

.button:disabled {
  cursor: not-allowed;
  opacity: 0.5;
}

.empty-state {
  margin: 0;
  padding: 16px;
  border: 1px dashed var(--color-border-strong);
  border-radius: 5px;
  color: var(--color-muted);
  background: var(--color-sidebar);
  font-size: 0.9rem;
}
</style>
