<script setup>
defineProps({
  isLoadingQuiz: Boolean,
  quizWord: Object,
  quizResult: String,
  hasAnswered: Boolean,
});
const emit = defineEmits(["fetch-quiz"]);
</script>
<template>
  <div v-if="quizWord" class="quiz-card">
    <p
      v-if="quizResult"
      class="quiz-result"
      :class="{ correct: quizResult === '正解' }"
    >
      {{ quizResult }}
    </p>
    <button
      v-if="hasAnswered"
      class="button"
      @click="emit('fetch-quiz')"
      :disabled="isLoadingQuiz"
    >
      {{ isLoadingQuiz ? "取得中..." : "次の問題" }}
    </button>
  </div>
</template>

<style scoped>
.quiz-card {
  display: grid;
  gap: 12px;
  margin-top: 12px;
  padding: 16px;
  border: 1px solid var(--color-border);
  border-radius: 5px;
  background: var(--color-canvas);
}

.quiz-result {
  margin: 0;
  padding: 10px 12px;
  border-radius: 4px;
  color: var(--color-danger);
  background: var(--color-danger-bg);
  font-size: 0.9rem;
  font-weight: 600;
}

.quiz-result.correct {
  color: var(--color-success);
  background: var(--color-success-bg);
}
</style>
