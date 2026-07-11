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
  <section class="panel">
    <div class="panel-header">
      <div>
        <h2 class="panel-title">{{ isEditing ? "単語を編集" : "単語を登録" }}</h2>
        <p class="panel-subtitle">英単語、日本語訳、例文をまとめて保存します。</p>
      </div>
    </div>

    <form class="word-form" @submit.prevent="emit('submit-word')">
      <label class="field">
        <span>英単語</span>
        <input
          :value="english"
          @input="emit('update:english', $event.target.value)"
          placeholder="example"
        />
      </label>
      <label class="field">
        <span>日本語訳</span>
        <input
          :value="japanese"
          @input="emit('update:japanese', $event.target.value)"
          placeholder="例"
        />
      </label>
      <label class="field field-wide">
        <span>例文</span>
        <textarea
          :value="exampleSentence"
          @input="emit('update:example-sentence', $event.target.value)"
          placeholder="This is an example sentence."
        ></textarea>
      </label>
      <button class="button submit-button" type="submit">
        {{ isEditing ? "変更を保存" : "登録する" }}
      </button>
    </form>
  </section>
</template>

<style scoped>
.word-form {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 16px;
}

.field {
  display: grid;
  gap: 8px;
  color: #34434a;
  font-size: 0.9rem;
  font-weight: 700;
}

.field-wide {
  grid-column: 1 / -1;
}

input,
textarea {
  width: 100%;
  border: 1px solid #cbd8d2;
  border-radius: 8px;
  color: #17212b;
  background: #fbfdfc;
}

input {
  min-height: 46px;
  padding: 0 14px;
}

textarea {
  min-height: 96px;
  resize: vertical;
  padding: 12px 14px;
}

input::placeholder,
textarea::placeholder {
  color: #9aa6ac;
}

.submit-button {
  grid-column: 1 / -1;
  justify-self: end;
  min-width: 150px;
}

@media (max-width: 640px) {
  .word-form {
    grid-template-columns: 1fr;
  }

  .submit-button {
    width: 100%;
  }
}
</style>
