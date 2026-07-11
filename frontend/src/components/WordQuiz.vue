<script setup>
import { ref } from "vue";

const quizWord = ref(null);
const answer = ref("");
const quizResult = ref("");

const fetchQuiz = async () => {
  const response = await fetch("http://localhost:3000/quiz");
  const data = await response.json();
  quizWord.value = data;
  quizResult.value = "";
  answer.value = "";
};
const checkanswer = async () => {
  const isCorrect = answer.value === quizWord.value.japanese;
  if (isCorrect) {
    quizResult.value = "正解";
  } else {
    quizResult.value = `不正解。正解は ${quizWord.value.japanese}`;
  }

  await fetch("http://localhost:3000/study_histories", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      study_history: {
        word_id: quizWord.value.id,
        correct: isCorrect,
      },
    }),
  });
};
</script>
<template>
  <section class="panel quiz-panel">
    <div class="panel-header">
      <div>
        <h2 class="panel-title">クイズ</h2>
        <p class="panel-subtitle">英単語を見て日本語訳を答えます。</p>
      </div>
    </div>

    <button class="button" @click="fetchQuiz">問題を出す</button>

    <div v-if="quizWord" class="quiz-card">
      <p class="quiz-label">問題</p>
      <p class="quiz-word">{{ quizWord.english }}</p>

      <div class="answer-row">
        <input v-model="answer" placeholder="日本語を入力" />
        <button class="button secondary" @click="checkanswer">回答する</button>
      </div>
      <p
        v-if="quizResult"
        class="quiz-result"
        :class="{ correct: quizResult === '正解' }"
      >
        {{ quizResult }}
      </p>
    </div>
  </section>
</template>

<style scoped>
.quiz-panel {
  overflow: hidden;
}

.quiz-card {
  display: grid;
  gap: 12px;
  margin-top: 16px;
  padding: 18px;
  border: 1px solid #d7e7e3;
  border-radius: 8px;
  background: #f2faf8;
}

.quiz-label {
  margin: 0;
  color: #66747c;
  font-size: 0.82rem;
  font-weight: 800;
}

.quiz-word {
  margin: 0;
  color: #17212b;
  font-size: 2rem;
  font-weight: 850;
  line-height: 1.1;
  overflow-wrap: anywhere;
}

.answer-row {
  display: grid;
  grid-template-columns: minmax(0, 1fr) auto;
  gap: 10px;
}

input {
  width: 100%;
  min-height: 42px;
  padding: 0 12px;
  border: 1px solid #cbd8d2;
  border-radius: 8px;
  color: #17212b;
  background: #ffffff;
}

.quiz-result {
  margin: 0;
  padding: 10px 12px;
  border-radius: 8px;
  color: #9b3527;
  background: #fff2ef;
  font-weight: 800;
}

.quiz-result.correct {
  color: #236f52;
  background: #e9f7ef;
}

@media (max-width: 520px) {
  .answer-row {
    grid-template-columns: 1fr;
  }
}
</style>
