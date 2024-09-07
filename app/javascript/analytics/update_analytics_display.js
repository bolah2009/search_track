// Update the DOM with the latest analytics data
const updateAnalyticsDisplay = (data) => {
  const topQueriesElement = document.querySelector('#top-queries');
  const recentQueriesElement =
    document.querySelector('#recent-queries');
  const topQueriesSectionElement = document.querySelector(
    '#top-queries-section'
  );
  const recentQueriesSectionElement = document.querySelector(
    '#recent-queries-section'
  );

  if (data.top_queries.length > 0) {
    // Display top queries
    topQueriesElement.innerHTML = data.top_queries
      .map(
        (query) => `
                <tr class="hover:bg-gray-100">
                  <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-800">${query[0]}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-800">${query[1]}</td>
                </tr>`
      )
      .join('');
    topQueriesSectionElement.classList.remove('hidden');
  }

  if (data.recent_queries.length > 0) {
    // Display recent queries
    console.debug({recent_queries: data.recent_queries})
    recentQueriesElement.innerHTML = data.recent_queries
      .map(
        (query) =>`
                <tr class="hover:bg-gray-100">
                  <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-800">${query[0]}</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-800">${query[1]}</td>
                </tr>`
      )
      .join('');
    recentQueriesSectionElement.classList.remove('hidden');
  }
};

export default updateAnalyticsDisplay;
