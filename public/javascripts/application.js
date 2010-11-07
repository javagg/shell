$(document).ready(function() {
    function delete_document() {
        $('#documents-list a.delete').bind('click', function() {
            //            var delete_link = $(this)
            //            $.ajax({
            //                type: 'delete',
            //                url: delete_link.attr('href'),
            //                success: function() { delete_link.parent().parent().remove() }
            //            })
            Boxy.confirm("Please confirm:", function() {
                alert('Confirmed!');
            }, {
                title: 'Message'
            });
            return false;
        })
    }

    function CreateProduct() {//添加product函数
        $('#create-product').submit(function() {//点击submit的函数
            $(this).ajaxSubmit({//点击submit发起ajax请求
                target: '#products-list',  //目标是对id=product0list的dom进行局部更新
                clearForm: true,
                success: DeleteProduct,
                error: displayError//发生错误,譬如validate?为false时
            })
            return false
        })
    }

    function display_error(request, errorType) {
        var msg = '<div class="error">'+request.responseText+'(click to close)</div>'
        $('#products-list').append(msg)
        $('.error').click(function(){
            $(this).hide()
        })
    }

    $(function() {
        delete_document()
        CreateProduct()
    })

});

var $j = jQuery.noConflict()
$j(document).ready(function() {
  function delete_document() {
             //            var delete_link = $(this)
            //            $.ajax({
            //                type: 'delete',
            //                url: delete_link.attr('href'),
            //                success: function() { delete_link.parent().parent().remove() }
            //            })
            Boxy.confirm("Please confirm:", function() {
                alert('Confirmed!');
            }, {
                title: 'Message'
            });
            return false;
    }
});
