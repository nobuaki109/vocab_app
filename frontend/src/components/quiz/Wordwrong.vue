<script setup>
import { ref } from "vue";
const wrongHistories = ref([]);
const fetchWrongHistories = async () => {
  const response = await fetch(`${API_BASE_URL}/study_histories/wrong`);
  const data = await response.json();
  wrongHistories.value = data;
};
</script>
<template>
  <section class="panel">
    <div class="panel-header">
      <div>
        <h2 class="panel-title">不正解リスト</h2>
        <p class="panel-subtitle">間違えた単語をまとめて復習できます。</p>
      </div>
    </div>

    <button class="button secondary" @click="fetchWrongHistories">
      不正解一覧を表示
    </button>

    <p v-if="wrongHistories.length === 0" class="empty-state wrong-empty">
      まだ表示する単語がありません。
    </p>

    <ul v-else class="wrong-list">
      <li
        v-for="history in wrongHistories"
        :key="history.id"
        class="wrong-item"
      >
        <span class="wrong-english">{{ history.word?.english }}</span>
        <span class="wrong-japanese">{{ history.word?.japanese }}</span>
      </li>
    </ul>
  </section>
</template>

<style scoped>
.wrong-empty {
  margin-top: 14px;
}

.wrong-list {
  display: grid;
  gap: 10px;
  margin: 16px 0 0;
  padding: 0;
  list-style: none;
}

.wrong-item {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  gap: 8px 14px;
  padding: 12px 14px;
  border: 1px solid #ead6d0;
  border-radius: 8px;
  background: #fffaf8;
}

.wrong-english {
  color: #17212b;
  font-weight: 800;
}

.wrong-japanese {
  color: #9b3527;
  font-weight: 700;
}
</style>
