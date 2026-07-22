<script setup>
import { ref } from "vue";
import QuizSettings from "./QuizSettings.vue";
import { API_BASE_URL } from "../../config/api.js";
import QuizQuestion from "./QuizQuestion.vue";
import QuizResult from "./QuizResult.vue";

const quizWord = ref(null);
const answer = ref("");
const quizResult = ref("");
const quizMode = ref("random");
const hasAnswered = ref(false);
const isSubmitting = ref(false);
const isLoadingQuiz = ref(false);
const quizError = ref("");

const fetchQuiz = async () => {
  if (isLoadingQuiz.value || isSubmitting.value) {
    return;
  }
  const url =
    quizMode.value === "review"
      ? `${API_BASE_URL}/quiz?mode=review`
      : `${API_BASE_URL}/quiz`;

  isLoadingQuiz.value = true;
  quizError.value = "";
  quizWord.value = null;
  quizResult.value = "";
  answer.value = "";
  hasAnswered.value = false;
  try {
    const response = await fetch(url);
    if (!response.ok) {
      const errorData = await response.json();

      if (errorData.error === "No review words available") {
        throw new Error("復習は完了しました！");
      }
      if (errorData.error === "No words available") {
        throw new Error("出題できる単語がありません。");
      }
      throw new Error("問題の取得に失敗しました。");
    }
    const data = await response.json();
    quizWord.value = data;
    quizResult.value = "";
    answer.value = "";
    hasAnswered.value = false;
  } catch (error) {
    quizError.value = error.message;
  } finally {
    isLoadingQuiz.value = false;
  }
};
const checkanswer = async () => {
  if (hasAnswered.value || isSubmitting.value) {
    return;
  }
  if (!answer.value.trim()) {
    quizResult.value = "回答を入力してください";
    return;
  }

  const isCorrect = answer.value === quizWord.value.japanese;
  isSubmitting.value = true;

  try {
    const response = await fetch(`${API_BASE_URL}/study_histories`, {
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
    if (!response.ok) {
      throw new Error("学習履歴の保存に失敗しました。");
    }
    if (isCorrect) {
      quizResult.value = "正解";
    } else {
      quizResult.value = `不正解。正解は ${quizWord.value.japanese}`;
    }
    hasAnswered.value = true;
  } catch (error) {
    quizResult.value = error.message;
  } finally {
    isSubmitting.value = false;
  }
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

    <QuizSettings
      v-model:quiz-mode="quizMode"
      :disabled="isLoadingQuiz || isSubmitting"
    />
    <QuizQuestion
      v-model:answer="answer"
      :quiz-word="quizWord"
      :disabled="isLoadingQuiz || isSubmitting"
      :is-submitting="isSubmitting"
      :is-loading-quiz="isLoadingQuiz"
      @fetch-quiz="fetchQuiz"
      @check-answer="checkanswer"
    />
    <QuizResult
      :quiz-word="quizWord"
      :quiz-result="quizResult"
      :has-answered="hasAnswered"
      :is-loading-quiz="isLoadingQuiz"
      @next-question="fetchQuiz"
    />
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
