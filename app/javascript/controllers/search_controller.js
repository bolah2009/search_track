import { Controller } from '@hotwired/stimulus';
import searchChannel from 'channels/search_channel';
import { v4 as uuidv4 } from 'uuid';

export default class extends Controller {
  initialize() {
    const debounce = (func, wait) => {
      let timeout;

      return (...args) => {
        clearTimeout(timeout);
        timeout = setTimeout(() => func(...args), wait);
      };
    };

    const searchInput = document.querySelector('#search-box');
    let searchSessionId = null;
    const ipAddress = searchInput.dataset.ipAddress; // Get the IP address from data attribute
    const newSearchChannel = searchChannel(ipAddress);
    const completeSearch = newSearchChannel.completeSearch.bind(newSearchChannel)
    const sendSearch = newSearchChannel.sendSearch.bind(newSearchChannel)
    
    function startNewSearchSession() {
      searchSessionId = uuidv4();
    }

    const debouncedSearch = debounce(() => {
      const query = searchInput.value.trim();
      console.debug({ query });
      if (query) {
        sendSearch(query, searchSessionId);
      }
    }, 1000); // Wait for 1 second before sending query to the server.

    searchInput.addEventListener('input', () => {
      if (!searchSessionId) {
        startNewSearchSession();
      }
      debouncedSearch();
    });

    const finalizeSearch = () => {
      const query = searchInput.value.trim();
      if (query) {
        if (!searchSessionId) {
          startNewSearchSession();
        }
        completeSearch(query, searchSessionId); // Mark search as complete
        searchSessionId = null; // Reset session ID
        searchInput.value = ''; // Reset input value
      }
    };
    
    // Listen for keyup to check if user pressed Enter (13 is the Enter keycode)
    searchInput.addEventListener('keyup', (event) => {
      if (event.keyCode === 13) { 
        finalizeSearch();
      }
    });
    
    // Listen for blur event when the user changes focus
    searchInput.addEventListener('blur', finalizeSearch);
    
    const debounceFinalization = debounce(finalizeSearch, 3000); // 3-second pause for completing query
    // Call debounce finalization on input
    searchInput.addEventListener('input', debounceFinalization);
  }
}
