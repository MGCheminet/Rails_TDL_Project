// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "controllers"


//= require jquery
//= require rails
//= require bootstrap
//= require rails-ujs
//= require turbolinks
//= require_tree .



document.addEventListener('DOMContentLoaded', () => {
  document.addEventListener('submit', (event) => {
    const deleteForm = event.target.closest('form[data-confirm]');
    if (deleteForm) {
      const message = deleteForm.dataset.confirm;
      if (!confirm(message)) {
        event.preventDefault();
      }
    }
  });
});





  
