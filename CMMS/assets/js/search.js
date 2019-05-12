$.fn.search = function (options) {
    var div = this;
    var input = '<input type="text" placeholder="' + options.placeholder + '"/>';
    div.css('width', options.width);
    div.append(input);
    input.on('keyup', function () {
        console.log(this);
        div.append('<ul><li>یاتاقان شماره 1</li></ul>');
    });
};