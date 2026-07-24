<script setup>
defineProps({
  quizMode: String,
  disabled: Boolean,
  quizDirection: String,
});
const emit = defineEmits(["update:quizMode", "update:quizDirection"]);
</script>
<template>
  <label>
    出題モード
    <select
      :value="quizMode"
      :disabled="disabled"
      @change="emit('update:quizMode', $event.target.value)"
    >
      <option value="random">通常クイズ</option>
      <option value="review">苦手を復習</option>
    </select>
  </label>
  <label>
    出題方向
    <select
      :value="quizDirection"
      :disabled="disabled"
      @change="emit('update:quizDirection', $event.target.value)"
    >
      <option>英語　→　日本語</option>
      <option>日本語　→　英語</option>
    </select>
  </label>
  <p class="quiz-label">
    {{ quizMode === "review" ? "苦手を復習" : "通常クイズ" }}
  </p>
</template>

<style scoped>
label {
  display: inline-grid;
  gap: 6px;
  margin: 0 12px 16px 0;
  color: var(--color-text);
  font-size: 0.82rem;
  font-weight: 600;
}

select {
  min-width: 180px;
  min-height: 38px;
  padding: 0 32px 0 10px;
  border: 1px solid var(--color-border-strong);
  border-radius: 4px;
  color: var(--color-text);
  background: var(--color-canvas);
}

select:hover {
  border-color: #b8b8b5;
}

select:disabled {
  cursor: not-allowed;
  opacity: 0.55;
}

.quiz-label {
  display: block;
  width: fit-content;
  margin: 0 0 16px;
  padding: 3px 8px;
  border-radius: 4px;
  color: var(--color-muted);
  background: var(--color-hover);
  font-size: 0.75rem;
  font-weight: 550;
}
</style>
