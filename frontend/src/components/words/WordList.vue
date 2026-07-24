<script setup>
import WordQuiz from "../quiz/WordQuiz.vue";

defineProps({
  words: Array,
  searchKeyword: String,
});
const emit = defineEmits(["delete-word", "edit-word", "update:search-keyword"]);
const playAudio = async (audioUrl) => {
  if (!audioUrl) {
    return;
  }
  try {
    const audio = new Audio(audioUrl);
    await audio.play();
  } catch {
    alert("音声を再生できませんでした。");
  }
};
</script>

<template>
  <section class="panel">
    <div class="panel-header">
      <label class="search-firld">
        <input
          :value="searchKeyword"
          @input="emit('update:search-keyword', $event.target.value)"
          placeholder="英単語・日本語訳で検索"
        />
      </label>
      <div>
        <h2 class="panel-title">単語一覧</h2>
        <p class="panel-subtitle">登録した単語を確認、編集できます。</p>
      </div>
      <span class="count-badge">{{ words.length }}</span>
    </div>

    <p v-if="words.length === 0" class="empty-state">
      まだ単語がありません。最初の単語を登録してみましょう。
    </p>

    <ul v-else class="word-list">
      <li v-for="word in words" :key="word.id" class="word-item">
        <div class="word-content">
          <div class="word-main">
            <span class="english">{{ word.english }}</span>
            <span class="japanese">{{ word.japanese }}</span>
            <span v-if="word.phonetic" class="phonetic">{{
              word.phonetic
            }}</span>
          </div>
          <p class="example">{{ word.example_sentence || "例文なし" }}</p>
        </div>

        <div class="word-actions">
          <button
            v-if="WordQuiz.audio_url"
            class="button secondary"
            type="button"
            @click="playAudio(word.audio_url)"
          >
            🔊 発音
          </button>
          <button class="button secondary" @click="emit('edit-word', word)">
            編集
          </button>
          <button class="button danger" @click="emit('delete-word', word.id)">
            削除
          </button>
        </div>
      </li>
    </ul>
  </section>
</template>

<style scoped>
.panel-header {
  display: grid;
  grid-template-columns: minmax(0, 1fr) auto;
}

.search-firld {
  grid-column: 1 / -1;
  grid-row: 2;
  display: block;
}

.search-firld input {
  width: 100%;
  min-height: 40px;
  padding: 0 11px;
  border: 1px solid var(--color-border-strong);
  border-radius: 4px;
  color: var(--color-text);
  background: var(--color-canvas);
}

.search-firld input::placeholder {
  color: var(--color-faint);
}

.count-badge {
  display: inline-grid;
  min-width: 30px;
  height: 30px;
  padding: 0 8px;
  place-items: center;
  border-radius: 4px;
  color: var(--color-muted);
  background: var(--color-hover);
  font-size: 0.82rem;
  font-weight: 600;
}

.word-list {
  display: grid;
  gap: 0;
  margin: 0;
  padding: 0;
  border-top: 1px solid var(--color-border);
  list-style: none;
}

.word-item {
  display: grid;
  grid-template-columns: minmax(0, 1fr) auto;
  gap: 16px;
  align-items: center;
  padding: 15px 8px;
  border-bottom: 1px solid var(--color-border);
  background: transparent;
  transition: background-color 120ms ease;
}

.word-item:hover {
  background: var(--color-sidebar);
}

.word-content {
  min-width: 0;
}

.word-main {
  display: flex;
  flex-wrap: wrap;
  align-items: baseline;
  gap: 8px 12px;
}

.english {
  color: var(--color-text);
  font-size: 1.05rem;
  font-weight: 650;
}

.japanese {
  color: var(--color-muted);
  font-size: 0.92rem;
  font-weight: 500;
}

.example {
  margin: 6px 0 0;
  color: var(--color-muted);
  font-size: 0.88rem;
  overflow-wrap: anywhere;
}

.word-actions {
  display: flex;
  gap: 6px;
}
.phonetic {
  color: var(--color-muted);
  font-size: 0.86rem;
  font-weight: 400;
}

@media (max-width: 640px) {
  .word-item {
    grid-template-columns: 1fr;
  }

  .word-actions {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(90px, 1fr));
  }
}
</style>
