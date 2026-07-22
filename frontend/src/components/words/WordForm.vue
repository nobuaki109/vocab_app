<script setup>
defineProps({
  english: String,
  japanese: String,
  exampleSentence: String,
  isEditing: Boolean,
  formErrors: Object,
  isLookingUpWord: Boolean,
});
const emit = defineEmits([
  "update:english",
  "update:japanese",
  "update:example-sentence",
  "submit-word",
  "cancel-edit",
  "reset-form",
  "lookup-word",
]);
</script>

<template>
  <section class="panel">
    <div class="panel-header">
      <div>
        <h2 class="panel-title">
          {{ isEditing ? "単語を編集" : "単語を登録" }}
        </h2>
        <p class="panel-subtitle">
          英単語、日本語訳、例文をまとめて保存します。
        </p>
      </div>
    </div>

    <form class="word-form" @submit.prevent="emit('submit-word')">
      <label class="field">
        <span>英単語</span>
        <div class="lookup-row">
          <input
            :value="english"
            @input="emit('update:english', $event.target.value)"
            placeholder="example"
          />
          <button
            class="button secondary"
            type="button"
            @click="emit('lookup-word')"
          >
            {{ isLookingUpWord ? "検索中..." : "検索" }}
          </button>
        </div>

        <p v-if="formErrors?.english" class="field-error">
          {{ formErrors.english }}
        </p>
      </label>
      <label class="field">
        <span>日本語訳</span>
        <input
          :value="japanese"
          @input="emit('update:japanese', $event.target.value)"
          placeholder="例"
        />
        <p v-if="formErrors?.japanese" class="field-error">
          {{ formErrors.japanese }}
        </p>
      </label>
      <label class="field field-wide">
        <span>例文</span>
        <textarea
          :value="exampleSentence"
          @input="emit('update:example-sentence', $event.target.value)"
          placeholder="This is an example sentence."
        ></textarea>
      </label>
      <div class="form-actions">
        <button class="button submit-button" type="submit">
          {{ isEditing ? "変更を保存" : "登録する" }}
        </button>
        <button
          v-if="!isEditing"
          class="button secondary"
          type="button"
          @click="emit('reset-form')"
        >
          リセット
        </button>

        <button
          v-if="isEditing"
          class="button secondary"
          type="button"
          @click="emit('cancel-edit')"
        >
          キャンセル
        </button>
      </div>
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
.field-error {
  margin: 0;
  color: #9b3527;
  font-size: 0.84rem;
  font-weight: 700;
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

@media (max-width: 640px) {
  .word-form {
    grid-template-columns: 1fr;
  }

  .form-actions {
    display: grid;
  }

  .submit-button,
  .form-actions .button {
    width: 100%;
  }
}
.form-actions {
  grid-column: 1 / -1;
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}

.submit-button {
  min-width: 150px;
}
</style>
