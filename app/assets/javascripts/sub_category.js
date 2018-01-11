$(document).on('turbolinks:load', function() {
    const replaceSelectOptions = function($select, results) {
      $select.html($('<option>'));
      return $.each(results, function() {
        const option = $('<option>').val(this.id).text(this.name);
        return $select.append(option);
      });
    };

    const replaceChildrenOptions = function() {
      const { childrenPath } = $(this).find('option:selected').data();
      const $selectChildren = $(this).closest('form').find('.select-children');
      if (childrenPath != null) {
        return $.ajax({
          url: childrenPath,
          dataType: "json",
          success(results) {
            return replaceSelectOptions($selectChildren, results);
          },
          error(XMLHttpRequest, textStatus, errorThrown) {
            console.error("Error occurred in replaceChildrenOptions");
            console.log(`XMLHttpRequest: ${XMLHttpRequest.status}`);
            console.log(`textStatus: ${textStatus}`);
            return console.log(`errorThrown: ${errorThrown}`);
          }
        });
      } else {
        return replaceSelectOptions($selectChildren, []);
      }
    };

    return $('.select-parent').on({
      'change': replaceChildrenOptions});
});
