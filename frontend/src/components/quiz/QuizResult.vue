<script setup>
defineProps({
  disabled: String,
  isLoadingQuiz: Boolean,
  quizError: String,
  quizWord: String,
  quizResult: String,
  hasAnswered: Boolean,
});
const emit = defineEmits(["fetch-quiz", "check-answer"]);
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
