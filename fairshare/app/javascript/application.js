// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "bootstrap/dist/js/bootstrap";
import "bootstrap/dist/js/bootstrap.bundle";


//= require rails
//= require jquery
//= require jquery_ujs
//= require bootstrap


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




  
