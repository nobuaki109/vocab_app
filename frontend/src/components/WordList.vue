<script setup>
defineProps({
    words: Array
});
const emit = defineEmits(["delete-word", "edit-word"]);
</script>

<template>
    <ul>
        <li v-for="word in words" :key="word.id">
            {{ word.english }} - {{ word.japanese }} - {{ word.example_sentence }}

            <button @click="emit('delete-word', word.id)">削除</button>
            <button @click="emit('edit-word', word)">編集</button>
        </li>
    </ul>
</template>