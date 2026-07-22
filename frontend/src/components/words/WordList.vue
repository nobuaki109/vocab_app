<script setup>
defineProps({
  words: Array,
  searchKeyword: String,
});
const emit = defineEmits(["delete-word", "edit-word", "update:search-keyword"]);
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
          </div>
          <p class="example">{{ word.example_sentence || "例文なし" }}</p>
        </div>

        <div class="word-actions">
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
.count-badge {
  display: inline-grid;
  min-width: 36px;
  height: 36px;
  place-items: center;
  border-radius: 8px;
  color: #26796d;
  background: #e6f4f1;
  font-weight: 800;
}

.word-list {
  display: grid;
  gap: 12px;
  margin: 0;
  padding: 0;
  list-style: none;
}

.word-item {
  display: grid;
  grid-template-columns: minmax(0, 1fr) auto;
  gap: 16px;
  align-items: center;
  padding: 16px;
  border: 1px solid #e3ebe7;
  border-radius: 8px;
  background: #fbfdfc;
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
  color: #17212b;
  font-size: 1.18rem;
  font-weight: 800;
}

.japanese {
  color: #26796d;
  font-weight: 700;
}

.example {
  margin: 8px 0 0;
  color: #66747c;
  overflow-wrap: anywhere;
}

.word-actions {
  display: flex;
  gap: 8px;
}

@media (max-width: 640px) {
  .word-item {
    grid-template-columns: 1fr;
  }

  .word-actions {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}
</style>
