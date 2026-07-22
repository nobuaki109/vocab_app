<script setup>
defineProps({
  disabled: String,
  answer: String,
  isSubmitting: Boolean,
  isLoadingQuiz: Boolean,
  quizError: String,
  quizWord: String,
});
const emit = defineEmits(["update:answer", "fetch-quiz", "check-answer"]);
</script>
<template>
  <button
    class="button"
    :disabled="isLoadingQuiz || isSubmitting"
    @click="fetchQuiz"
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
        v-model="answer"
        placeholder="日本語を入力"
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
