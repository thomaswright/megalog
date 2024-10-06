# Megalog

A journal entry app.

## Use

There are three main sections: the day list, the month list, and the entry list.

In the day and month list you can click to make an entry or go to that entry if it already exists. Command + click goes to the nearest entry without creating a new one. There is a dedicated "Today" button next to the viewed years adjustments.

When created, entries are unlocked and editable. You can add a title after the date and entry content below. Change the entry date by clicking the calendar icon. The trash icon deletes and the eye icon hides the entry content. You can then lock the entry to prevent further changes.

Clicking on "Megalog" pulls up the options menu. You can change to dark mode / light mode and toggle lock / unlock and hide / show for all entries. You can also export all entries for backup.

There is also an import option. This depends on a json file of an array of entries specified as `{"title": string, "date": dateString, "content": string}`. DateString is parsed as

```
2024: 2024
2024-06: June 2024
2024-06-30: 30th of June, 2024
2024-Q2: Second quarter 2024
2024-W8: The 8th week of 2024
```

Entries are stored in your browser's local storage otherwise. There is no option for cloud backup.

## Development

Run ReScript in dev mode:

```sh
npm run res:dev
```

In another tab, run the Vite dev server:

```sh
npm run dev
```
