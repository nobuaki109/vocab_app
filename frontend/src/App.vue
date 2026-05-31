<script setup>
import {ref,onMounted} from "vue";
import WordList from "./components/WordList.vue";
import WordForm from "./components/WordForm.vue";
import WordQuiz from "./components/WordQuiz.vue";
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
const createWord = async ()=> {
  errors.value = [];
  const response = await fetch("http://localhost:3000/words",{
    method: 'POST',
    headers:{
      'Content-Type':'application/json',
    },
    body: JSON.stringify({
      word:{
        english: english.value,
        japanese: japanese.value,
        example_sentence: exampleSentence.value,
      },
    }),
  });
  if(!response.ok){
    const errorData = await response.json();
    errors.value = errorData.errors;
    return;
  };
  const result = await response.json()
  alert('送信完了！')
  words.value.unshift(result)
  english.value = "";
  japanese.value = "";
  exampleSentence.value = "";
};
const destroyWord = async (id)=> {
  const response = await fetch(`http://localhost:3000/words/${id}`,{
    method:"DELETE"
  });
  if(!response.ok){
    alert("削除に失敗しました");
    return;
  }
  words.value = words.value.filter((word) => word.id != id );
};
const startEdit = (word) =>{
  editingWordId.value = word.id;
  english.value = word.english;
  japanese.value = word.japanese;
  exampleSentence.value = word.example_sentence;
};
const updateWord = async () => {
  errors.value = [];
  const response = await fetch(`http://localhost:3000/words/${editingWordId.value}`,{
    method: "PATCH",
    headers:{
      'Content-Type':'application/json',
    },
    body: JSON.stringify({
      word:{
        english: english.value,
        japanese: japanese.value,
        example_sentence: exampleSentence.value,
      },
    }),
  });
  if(!response.ok){
    const errorData = await response.json();
    errors.value = errorData.errors;
    return;
  };
  const updatedWord = await response.json();
  words.value = words.value.map((word) =>{
    if(word.id===updatedWord.id){
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
  <main>
    <h1>{{title}}</h1>
    <ul v-if="errors.length>0">
      <li v-for="error in errors" :key="error">
        {{error}}
      </li>
    </ul>
    <WordList
      :words="words"
      @delete-word="destroyWord"
      @edit-word="startEdit"
    />
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
    <WordQuiz
    />

  </main>
</template>
