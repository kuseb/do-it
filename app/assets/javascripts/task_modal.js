
var ft;

function initTaskTable(isAddEnable, isEditSite, listId) {

    var $modal = $('#list-editor'),
        $editor = $('#editor'),
        $editorTitle = $('#editor-title');

    if (isAddEnable) {
        ft = FooTable.init('#task_table', {
            editing: {
                enabled: isEditSite,
                addRow: function () {
                    $modal.removeData('row');
                    $editor[0].reset();
                    $editorTitle.text('Add new task');
                    $modal.modal('show');
                },
                editRow: function (row) {
                    var values = row.val();

                    $editor.find('#id').val(values.id);
                    $editor.find('#content').val(values.content);
                    $editor.find('#importance').val(values.importance);

                    if (values.deadline != null && values.deadline != '')
                        $editor.find('#deadline').val(moment(values.deadline).format('YYYY-MM-DD'));
                    else
                        $editor.find('#deadline').val(values.deadline);

                    $editor.find('#is_done').val(values.is_done);
                    $editor.find('#list_id').val(values.list_id);

                    $modal.data('row', row);
                    $editorTitle.text('Edit task');
                    $modal.modal('show');

                    if (values.is_done === 'true')
                        $('.icheck-me').iCheck('check');
                    else
                        $('.icheck-me').iCheck('uncheck');

                },
                deleteRow: function (row) {
                    if (confirm('Are you sure you want to delete this task?')) {
                        $.ajax({
                            type: "DELETE",
                            dataType: "json",
                            url: "/tasks/" + row.val().id,
                            success: function (data) {
                                row.delete();
                            }
                        });
                    }
                }
            }
        });
    }
    else {
        ft = FooTable.init('#task_table', {
            editing: {
                enabled: isEditSite,
                allowAdd: false,
                editRow: function (row) {
                    var values = row.val();

                    $editor.find('#id').val(values.id);
                    $editor.find('#content').val(values.content);
                    $editor.find('#importance').val(values.importance);

                    if (values.deadline != null && values.deadline != '')
                        $editor.find('#deadline').val(moment(values.deadline).format('YYYY-MM-DD'));
                    else
                        $editor.find('#deadline').val(values.deadline);

                    $editor.find('#is_done').val(values.is_done);
                    $editor.find('#list_id').val(values.list_id);

                    $modal.data('row', row);
                    $editorTitle.text('Edit task');
                    $modal.modal('show');

                    if (values.is_done)
                        $('.icheck-me').iCheck('check');
                },
                deleteRow: function (row) {
                    if (confirm('Are you sure you want to delete this task?')) {
                        $.ajax({
                            type: "DELETE",
                            dataType: "json",
                            url: "/tasks/" + row.val().id,
                            success: function (data) {
                                row.delete();
                            }
                        });
                    }
                }
            }
        });
    }

    $editor.on('submit', function (e) {
        if (this.checkValidity && !this.checkValidity()) return;
        e.preventDefault();
        var row = $modal.data('row'),
            values = {
                id: $editor.find('#id').val(),
                content: $editor.find('#content').val(),
                importance: $editor.find('#importance').val(),
                is_done: $editor.find('#is_done').val(),
                list_id: $editor.find('#list_id').val()
            };
        if ($editor.find('#deadline').val() == "")
            values.deadline = "";
        else
            values.deadline = moment.utc($editor.find('#deadline').val()).format();

        // Edit operation
        if (row instanceof FooTable.Row) {
            values._method = 'put';
            $.ajax({
                type: "PATCH",
                dataType: "json",
                url: "/tasks/" + values.id,
                contentType: 'application/json',
                data: JSON.stringify(values),
                success: function (data) {
                    if (values.deadline != null && values.deadline != '')
                        values.deadline = moment(values.deadline).format('YYYY-MM-DD');
                    $('#task_modal_submit').attr("disabled", false);
                    /* row.val(values);*/
                }
            });
        } //Add operation
        else {
            delete values.id;
            values.list_id = listId;
            $.ajax({
                type: "POST",
                dataType: "json",
                url: "/tasks",
                contentType: 'application/json',
                data: JSON.stringify(values),
                success: function (data) {
                    values.id = data.id;
                    console.log(values.deadline);
                    $('#task_modal_submit').attr("disabled", false);
                    /* ft.rows.add(values);*/
                }
            });
        }
        $modal.modal('hide');

    });

}