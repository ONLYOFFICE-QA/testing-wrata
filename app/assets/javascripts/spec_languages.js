// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

const SPEC_LANGUAGE_ALL = 'All Languages';

function getSpecLanguage() {
    return $('#language_0').val();
}

function addAllLanguagesToSelect() {
    return $('#language_0').append($("<option/>", {
        value: SPEC_LANGUAGE_ALL,
        text: SPEC_LANGUAGE_ALL
    }));
}