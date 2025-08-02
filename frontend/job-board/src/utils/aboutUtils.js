export const getAboutFromLocalStorage = () => {
  const data = localStorage.getItem('aboutContent');
  return data ? JSON.parse(data) : null;
};

export const saveAboutToLocalStorage = (content) => {
  localStorage.setItem('aboutContent', JSON.stringify(content));
};