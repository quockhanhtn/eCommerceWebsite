const FORM_ID = 'product-category-edit-form';

let id = document.getElementById('id');

let productCategoryName = document.getElementById('gender');

let isValidate = true;

function checkInputs() {
  // trim to remove the whitespaces
  let productCategoryNameValue = productCategoryName.value.trim();

  isValidate = true;

  if (productCategoryNameValue === '') {
    setErrorFor(productCategoryName, 'Vui lòng nhập tên ngành hàng');
  } else {
    setSuccessFor(productCategoryName);
  }
}

function setErrorFor(input, message) {
  if (isValidate) {
    input.focus();
  }

  isValidate = false;

  input.parentElement.className = 'has-danger';
  input.className = 'form-control is-invalid';

  let small = input.parentElement.parentElement.querySelector('small');
  small.innerText = message;
  small.setAttribute("style", "display: inline;");
}

function setSuccessFor(input) {
  input.parentElement.className = 'has-success';
  input.className = 'form-control is-valid';

  let small = input.parentElement.parentElement.querySelector('small');
  small.innerText = '';
  small.setAttribute("style", "display: none;");
}

function encodeImgToBase64(element) {
  let img = element.files[0];
  let imgReader = new FileReader();
  imgReader.onloadend = function() {
    $('#img-upload').attr('class','mb-2 rounded avatar-img');
    $('#img-upload').attr('src',imgReader.result);
  }
  imgReader.readAsDataURL(img);
}

$('#' + FORM_ID).submit(function (e) {
  checkInputs();


  if (!isValidate) {
    e.preventDefault();
  } else {
    $.ajax({
      url: '/api/employees',
      method: 'PUT',
      async: false,
      data: {
        'productCategoryId': id.value,
        'productCategoryName': productCategoryName.value.trim(),
        'imageBase64': $('#img-upload').attr('src')
      },
      success: function (data, textStatus, jqXHR) {
        let result = data.toString().split('\n');
        if (result[0] === 'true') {
          $('#' + FORM_ID).trigger("reset");
          alert("Cập nhật thông tin thành công !");
        } else {
          alert("Lỗi: " + result[1]);
          e.preventDefault();
        }
      },
      error: function (jqXHR, textStatus, errorThrown) {
        alert("Lỗi: " + errorThrown);
        e.preventDefault();
      }
    });
  }
});

$('#btn-cancel').click(function () {
  $('#' + FORM_ID).trigger("reset");
});