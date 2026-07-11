<script setup>
import { ref, onMounted } from "vue";
import WordList from "./components/WordList.vue";
import WordForm from "./components/WordForm.vue";
import WordQuiz from "./components/WordQuiz.vue";
import Wordwrong from "./components/Wordwrong.vue";
const words = ref([]);
const english = ref("");
const japanese = ref("");
const exampleSentence = ref("");
const title = ref("単語一覧アプリ");
const errors = ref([]);
const editingWordId = ref(null);
onMounted(async () => {
  const response = await fetch("http://localhost:3000/words");
  const data = await response.json();
  words.value = data;
});
const createWord = async () => {
  errors.value = [];
  const response = await fetch("http://localhost:3000/words", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      word: {
        english: english.value,
        japanese: japanese.value,
        example_sentence: exampleSentence.value,
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
  english.value = "";
  japanese.value = "";
  exampleSentence.value = "";
};
const destroyWord = async (id) => {
  const response = await fetch(`http://localhost:3000/words/${id}`, {
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
};
const updateWord = async () => {
  errors.value = [];
  const response = await fetch(
    `http://localhost:3000/words/${editingWordId.value}`,
    {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        word: {
          english: english.value,
          japanese: japanese.value,
          example_sentence: exampleSentence.value,
        },
      }),
    },
  );
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
  editingWordId.value = null;
  english.value = "";
  japanese.value = "";
  exampleSentence.value = "";
};
</script>
<template>
  <main class="app-shell">
    <section class="hero">
      <div>
        <p class="eyebrow">Vocabulary Notebook</p>
        <h1>{{ title }}</h1>
        <p class="lead">
          登録、復習、間違えた単語の確認までをひとつの画面で進められます。
        </p>
      </div>
      <div class="summary">
        <span class="summary-number">{{ words.length }}</span>
        <span class="summary-label">登録単語</span>
      </div>
    </section>

    <ul v-if="errors.length > 0" class="error-list">
      <li v-for="error in errors" :key="error">
        {{ error }}
      </li>
    </ul>

    <section class="workspace">
      <div class="main-column">
        <WordForm
          :english="english"
          :japanese="japanese"
          :example-sentence="exampleSentence"
          :is-editing="!!editingWordId"
          @update:english="english = $event"
          @update:japanese="japanese = $event"
          @update:example-sentence="exampleSentence = $event"
          @submit-word="editingWordId ? updateWord() : createWord()"
        />
        <WordList
          :words="words"
          @delete-word="destroyWord"
          @edit-word="startEdit"
        />
      </div>
      <aside class="side-column">
        <WordQuiz />
        <Wordwrong />
      </aside>
    </section>
  </main>
</template>

<style>
:root {
  color: #17212b;
  background: #f4f7f5;
  font-family:
    Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI",
    sans-serif;
  font-synthesis: none;
  line-height: 1.5;
  text-rendering: optimizeLegibility;
}

* {
  box-sizing: border-box;
}

body {
  margin: 0;
  min-width: 320px;
  min-height: 100vh;
  background:
    linear-gradient(135deg, rgba(38, 121, 109, 0.08), transparent 38%),
    linear-gradient(315deg, rgba(211, 85, 62, 0.09), transparent 34%),
    #f4f7f5;
}

button,
input,
textarea {
  font: inherit;
}

button {
  border: 0;
  cursor: pointer;
}

button:focus-visible,
input:focus-visible,
textarea:focus-visible {
  outline: 3px solid rgba(38, 121, 109, 0.28);
  outline-offset: 2px;
}

.app-shell {
  width: min(1120px, calc(100% - 32px));
  margin: 0 auto;
  padding: 36px 0 48px;
}

.hero {
  display: flex;
  align-items: end;
  justify-content: space-between;
  gap: 24px;
  padding: 30px;
  border: 1px solid #dbe5df;
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.82);
  box-shadow: 0 18px 50px rgba(36, 52, 45, 0.08);
}

.eyebrow {
  margin: 0 0 8px;
  color: #26796d;
  font-size: 0.78rem;
  font-weight: 700;
  letter-spacing: 0;
  text-transform: uppercase;
}

h1 {
  margin: 0;
  font-size: clamp(2rem, 5vw, 3.6rem);
  line-height: 1.04;
}

.lead {
  max-width: 610px;
  margin: 14px 0 0;
  color: #59666f;
  font-size: 1rem;
}

.summary {
  display: grid;
  min-width: 128px;
  padding: 18px;
  border-left: 4px solid #d3553e;
  background: #fff8f5;
}

.summary-number {
  color: #17212b;
  font-size: 2.5rem;
  font-weight: 800;
  line-height: 1;
}

.summary-label {
  margin-top: 4px;
  color: #7c4b3f;
  font-size: 0.9rem;
  font-weight: 700;
}

.error-list {
  margin: 18px 0 0;
  padding: 14px 18px 14px 36px;
  border: 1px solid #f1b7aa;
  border-radius: 8px;
  color: #8e2f22;
  background: #fff2ef;
}

.workspace {
  display: grid;
  grid-template-columns: minmax(0, 1.5fr) minmax(320px, 0.9fr);
  gap: 20px;
  margin-top: 20px;
}

.main-column,
.side-column {
  display: grid;
  gap: 20px;
  align-content: start;
}

.panel {
  padding: 22px;
  border: 1px solid #dbe5df;
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.9);
  box-shadow: 0 12px 30px rgba(36, 52, 45, 0.07);
}

.panel-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 18px;
}

.panel-title {
  margin: 0;
  color: #17212b;
  font-size: 1.12rem;
  line-height: 1.3;
}

.panel-subtitle {
  margin: 4px 0 0;
  color: #66747c;
  font-size: 0.9rem;
}

.button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-height: 42px;
  padding: 0 16px;
  border-radius: 8px;
  color: #ffffff;
  background: #26796d;
  font-weight: 700;
  transition:
    transform 0.18s ease,
    box-shadow 0.18s ease,
    background-color 0.18s ease;
}

.button:hover {
  background: #1f675d;
  box-shadow: 0 10px 20px rgba(38, 121, 109, 0.18);
  transform: translateY(-1px);
}

.button.secondary {
  color: #26796d;
  border: 1px solid #bfd7d2;
  background: #eef8f6;
}

.button.secondary:hover {
  background: #e1f2ef;
}

.button.danger {
  color: #9b3527;
  border: 1px solid #efc2b8;
  background: #fff2ef;
}

.button.danger:hover {
  background: #ffe6df;
  box-shadow: 0 10px 20px rgba(155, 53, 39, 0.12);
}

.empty-state {
  margin: 0;
  padding: 18px;
  border: 1px dashed #c7d5ce;
  border-radius: 8px;
  color: #66747c;
  background: #f8fbf9;
}

@media (max-width: 860px) {
  .app-shell {
    width: min(100% - 24px, 680px);
    padding-top: 20px;
  }

  .hero,
  .workspace {
    grid-template-columns: 1fr;
  }

  .hero {
    display: grid;
    padding: 22px;
  }

  .summary {
    width: 100%;
  }
}
</style>
