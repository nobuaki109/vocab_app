<script setup>
import { ref } from "vue";

const quizWord = ref(null);
const answer = ref("");
const quizResult = ref("");

const fetchQuiz = async () => {
  const response = await fetch("http://localhost:3000/quiz");
  const data =await response.json();
  quizWord.value = data;
  quizResult.value = "";
  answer.value = "";
};
const checkanswer = async () => {
  const isCorrect = answer.value === quizWord.value.japanese;
  if(isCorrect){
    quizResult.value="正解";
  }else{
    quizResult.value=`不正解。正解${quizWord.value.japanese}`;
  }

  await fetch("http://localhost:3000/study_histories",{
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
    <h2>クイズ</h2>
    <button @click="fetchQuiz">問題を出す</button>
    <div v-if="quizWord">
        <p>{{ quizWord.english }}</p>

    <input 
    v-model="answer" 
    placeholder="日本語を入力" 
    />
    <button @click="checkanswer">回答する</button>
    <p>{{ quizResult }}</p> 
    </div>
</template>