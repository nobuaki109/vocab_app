<script setup>
import { computed, ref } from "vue";
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
const quizDirection = ref("en_to_ja");

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
  const normalizeAnswer = (value) => {
    return value.trim().toLowerCase().replace(/\s+/g, " ");
  };

  const isCorrect =
    normalizeAnswer(answer.value) === normalizeAnswer(quizWord.value.japanese);
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

const questionText = computed(() => {
  if (!quizWord.value) {
    return "";
  }
  return quizDirection.value === "en_to_ja"
    ? quizWord.value.english
    : quizWord.value.japanese;
});
const answerPlaceholder = computed(() => {
  return quizDirection.value === "en_to_ja" ? "日本語を入力" : "英語を入力";
});
const playAudio = (audioUrl) => {
  if (!audioUrl) {
    return;
  }
  try {
    const audio = new Audio(audioUrl);
    audio.play();
  } catch {
    alert("音声を再生できませんでした。");
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
      v-model:quiz-direction="quizDirection"
      :disabled="isLoadingQuiz || isSubmitting"
    />
    <QuizQuestion
      v-model:answer="answer"
      :quiz-word="quizWord"
      :disabled="isLoadingQuiz || isSubmitting"
      :is-submitting="isSubmitting"
      :is-loading-quiz="isLoadingQuiz"
      :quiz-error="quizError"
      :question-text="questionText"
      :answer-placeholder="answerPlaceholder"
      @fetch-quiz="fetchQuiz"
      @check-answer="checkanswer"
    />
    <button
      v-if="quizWord?.audio_url"
      class="button secondary"
      type="button"
      @click="playAudio(quizWord.audio_url)"
    >
      🔊 発音
    </button>
    <QuizResult
      :quiz-word="quizWord"
      :quiz-result="quizResult"
      :has-answered="hasAnswered"
      :is-loading-quiz="isLoadingQuiz"
      @fetch-quiz="fetchQuiz"
    />
  </section>
</template>

<style scoped>
.quiz-panel {
  overflow: hidden;
}
</style>
