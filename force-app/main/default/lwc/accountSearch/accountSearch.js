import { LightningElement, track } from 'lwc';
import searchAccounts from '@salesforce/apex/AccountSearchController.searchAccounts';

export default class AccountSearch extends LightningElement {
    @track searchTerm = '';     // Tracks the search term entered by the user
    @track accounts;            // Holds the list of matching accounts

    // Handles the input change event from the search box
    handleSearchInput(event) {
        this.searchTerm = event.target.value;
        this.fetchAccounts();
    }

    // Calls the Apex controller to search accounts based on the search term
    fetchAccounts() {
        if (this.searchTerm.length > 2) { // Start searching after 3 characters
            searchAccounts({ searchTerm: this.searchTerm })
                .then((result) => {
                    this.accounts = result;
                })
                .catch((error) => {
                    console.error('Error fetching accounts:', error);
                    this.accounts = [];
                });
        } else {
            this.accounts = [];
        }
    }
}