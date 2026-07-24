<script setup>
import WordQuiz from "../quiz/WordQuiz.vue";

defineProps({
  english: String,
  japanese: String,
  exampleSentence: String,
  phonetic: String,
  audioUrl: String,
  isEditing: Boolean,
  formErrors: Object,
  isLookingUpWord: Boolean,
});
const emit = defineEmits([
  "update:english",
  "update:japanese",
  "update:example-sentence",
  "submit-word",
  "cancel-edit",
  "reset-form",
  "lookup-word",
]);
const playAudio = async (audioUrl) => {
  if (!audioUrl) {
    return;
  }

  try {
    const audio = new Audio(audioUrl);
    await audio.play();
  } catch {
    alert("音声を再生できませんでした。");
  }
};
</script>

<template>
  <section class="panel">
    <div class="panel-header">
      <div>
        <h2 class="panel-title">
          {{ isEditing ? "単語を編集" : "単語を登録" }}
        </h2>
        <p class="panel-subtitle">
          英単語、日本語訳、例文をまとめて保存します。
        </p>
      </div>
    </div>

    <form class="word-form" @submit.prevent="emit('submit-word')">
      <label class="field">
        <span>英単語</span>
        <div class="lookup-row">
          <input
            :value="english"
            @input="emit('update:english', $event.target.value)"
            placeholder="example"
          />
          <button
            class="button secondary"
            type="button"
            @click="emit('lookup-word')"
          >
            {{ isLookingUpWord ? "検索中..." : "検索" }}
          </button>
        </div>

        <p v-if="formErrors?.english" class="field-error">
          {{ formErrors.english }}
        </p>
      </label>
      <label class="field">
        <span>日本語訳</span>
        <input
          :value="japanese"
          @input="emit('update:japanese', $event.target.value)"
          placeholder="例"
        />
        <p v-if="formErrors?.japanese" class="field-error">
          {{ formErrors.japanese }}
        </p>
      </label>
      <div v-if="phonetic || audioUrl" class="pronunciation-preview">
        <div>
          <span class="preview-label">発音</span>
          <span v-if="phonetic" class="phonetic">
            {{ phonetic }}
          </span>
        </div>

        <button
          v-if="audioUrl"
          class="button secondary"
          type="button"
          @click="playAudio(audioUrl)"
        >
          🔊 音声を確認
        </button>
      </div>
      <label class="field field-wide">
        <span>例文</span>
        <textarea
          :value="exampleSentence"
          @input="emit('update:example-sentence', $event.target.value)"
          placeholder="This is an example sentence."
        ></textarea>
      </label>
      <div class="form-actions">
        <button class="button submit-button" type="submit">
          {{ isEditing ? "変更を保存" : "登録する" }}
        </button>
        <button
          v-if="!isEditing"
          class="button secondary"
          type="button"
          @click="emit('reset-form')"
        >
          リセット
        </button>

        <button
          v-if="isEditing"
          class="button secondary"
          type="button"
          @click="emit('cancel-edit')"
        >
          キャンセル
        </button>
      </div>
    </form>
  </section>
</template>

<style scoped>
.word-form {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 20px;
}

.field {
  display: grid;
  gap: 7px;
  color: var(--color-text);
  font-size: 0.84rem;
  font-weight: 600;
}

.field-wide {
  grid-column: 1 / -1;
}

.lookup-row {
  display: grid;
  grid-template-columns: minmax(0, 1fr) auto;
  gap: 8px;
}

.field-error {
  margin: 0;
  color: var(--color-danger);
  font-size: 0.8rem;
  font-weight: 500;
}

input,
textarea {
  width: 100%;
  border: 1px solid var(--color-border-strong);
  border-radius: 4px;
  color: var(--color-text);
  background: var(--color-canvas);
  transition:
    border-color 120ms ease,
    box-shadow 120ms ease;
}

input {
  min-height: 40px;
  padding: 0 11px;
}

textarea {
  min-height: 112px;
  resize: vertical;
  padding: 10px 11px;
}

input:hover,
textarea:hover {
  border-color: #b8b8b5;
}

input:focus,
textarea:focus {
  border-color: #9b9a97;
  box-shadow: 0 0 0 1px #9b9a97;
}

input::placeholder,
textarea::placeholder {
  color: var(--color-faint);
}

.pronunciation-preview {
  grid-column: 1 / -1;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 12px;
  border: 1px solid var(--color-border);
  border-radius: 4px;
  background: var(--color-sidebar);
}

.preview-label {
  margin-right: 10px;
  color: var(--color-muted);
  font-size: 0.78rem;
  font-weight: 600;
}

.phonetic {
  color: var(--color-text);
  font-size: 1rem;
}

@media (max-width: 640px) {
  .word-form {
    grid-template-columns: 1fr;
  }

  .form-actions {
    display: grid;
  }

  .submit-button,
  .form-actions .button {
    width: 100%;
  }
}
.form-actions {
  grid-column: 1 / -1;
  display: flex;
  justify-content: flex-end;
  gap: 8px;
  padding-top: 4px;
}

.submit-button {
  min-width: 120px;
}
</style>
