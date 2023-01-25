$(document).on('cocoon:after-insert', function(e, insertedSubTask) {
  var limit = 10; // フォームの最大数
  var count = $(e.target).find('[data-cocoon-exclude]').length; // data-cocoon-excludeがある要素の数をカウントする

  if (count > limit) {
    // フォームの上限を超えていたら、入力フォームを削除する
    insertedSubTask.remove();
    alert('フォームを追加できる上限に達しました');
  }
});