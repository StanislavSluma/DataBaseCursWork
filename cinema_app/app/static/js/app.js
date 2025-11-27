const API_BASE = '';

function formatDate(dateString) {
    const options = { year: 'numeric', month: 'long', day: 'numeric' };
    return new Date(dateString).toLocaleDateString('ru-RU', options);
}

function handleError(error) {
    console.error('Error:', error);
    alert('Произошла ошибка: ' + (error.response?.data?.detail || error.message));
}

function showToast(message, type = 'success') {
    alert(message);
}