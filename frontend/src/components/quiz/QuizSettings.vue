<script setup>
defineProps({
  quizMode: String,
  disabled: Boolean,
});
const emit = defineEmits(["update:quizMode"]);
</script>
<template>
  <label>
    出題モード
    <select
      v-model="quizMode"
      :disabled="disabled"
      @change="emit('update:quizMode', $event.target.value)"
    >
      <option value="random">通常クイズ</option>
      <option value="review">苦手を復習</option>
    </select>
  </label>
  <p class="quiz-label">
    {{ quizMode === "review" ? "苦手を復習" : "通常クイズ" }}
  </p>
</template>
