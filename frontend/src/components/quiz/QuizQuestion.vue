<script setup>
defineProps({
  disabled: Boolean,
  answer: String,
  isSubmitting: Boolean,
  isLoadingQuiz: Boolean,
  quizError: String,
  quizWord: Object,
  questionText: String,
  answerPlaceholder: String,
});
const emit = defineEmits(["update:answer", "fetch-quiz", "check-answer"]);
</script>
<template>
  <button
    class="button"
    :disabled="isLoadingQuiz || isSubmitting"
    @click="emit('fetchQuiz')"
  >
    問題を出す
  </button>
  <p v-if="quizError" class="quiz-result">
    {{ quizError }}
  </p>
  <div v-if="quizWord" class="quiz-card">
    <p class="quiz-label">問題</p>
    <p class="quiz-word">{{ quizWord.english }}</p>

    <div class="answer-row">
      <input
        :value="answer"
        :placeholder="answerPlaceholder"
        :disabled="disabled"
        @input="emit('update:answer', $event.target.value)"
      />
      <button
        class="button secondary"
        @click="emit('check-answer')"
        :disabled="disabled"
      >
        {{ isSubmitting ? "送信中..." : "回答する" }}
      </button>
    </div>
  </div>
</template>

<style scoped>
.quiz-card {
  display: grid;
  gap: 14px;
  margin-top: 20px;
  padding: 22px;
  border: 1px solid var(--color-border);
  border-radius: 5px;
  background: var(--color-sidebar);
}

.quiz-label {
  margin: 0;
  color: var(--color-muted);
  font-size: 0.76rem;
  font-weight: 600;
}

.quiz-word {
  margin: 0;
  color: var(--color-text);
  font-size: 2.1rem;
  font-weight: 650;
  line-height: 1.2;
  overflow-wrap: anywhere;
}

.answer-row {
  display: grid;
  grid-template-columns: minmax(0, 1fr) auto;
  gap: 8px;
}

input {
  width: 100%;
  min-height: 38px;
  padding: 0 11px;
  border: 1px solid var(--color-border-strong);
  border-radius: 4px;
  color: var(--color-text);
  background: var(--color-canvas);
}

input::placeholder {
  color: var(--color-faint);
}

.quiz-result {
  margin: 16px 0 0;
  padding: 10px 12px;
  border: 1px solid #f1c1bf;
  border-radius: 5px;
  color: var(--color-danger);
  background: var(--color-danger-bg);
  font-size: 0.88rem;
  font-weight: 550;
}

@media (max-width: 520px) {
  .answer-row {
    grid-template-columns: 1fr;
  }
}
</style>
