<script setup>
defineProps({
    english: String,
    japanese: String,
    exampleSentence: String,
    isEditing: Boolean,
});
const emit = defineEmits([
    "update:english",
    "update:japanese",
    "update:example-sentence",
    "submit-word",
]);
</script>

<template>
    <form @submit.prevent= "emit('submit-word')">
        <input 
            :value="english"
            @input="emit('update:english', $event.target.value)"
            placeholder="英単語"
        />
        <input 
            :value="japanese"
            @input="emit('update:japanese', $event.target.value)"
            placeholder="日本語訳"
        />
        <textarea
            :value="exampleSentence"
            @input="emit('update:example-sentence', $event.target.value)"
            placeholder="例文"
        ></textarea>
      <button type="submit">{{ isEditing ? "変更" : "登録"}}</button>
    </form> 
</template>