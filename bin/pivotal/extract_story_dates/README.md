Usage
-----

		$ ruby extract_story_dates.rb example.csv '2010-01-01'
		2010-06-05	true	12345
		2012-06-05	true	123456
		$ ruby extract_story_dates.rb example.csv '2010-07-01'
		2010-06-05	false	12345
		2012-06-05	true	123456

Suggestion
----------

Jared (*Oct 8, 2012*):

> If it's been more than two years since we discussed something with a
> client, then chances are good that we're not going to pick it back
> up any time soon. Let's pick a date to delete all icebox stories
> that haven't been touched in over two years. We'll give the clients
> a list of what will be deleted. The CSV export has dates for story
> and comments, so we can generate a list from that. What do you
> think?

Leon (*Oct 9, 2012*):

> I'm OK with this. It would be nice to have cleaner iceboxes in
> our long-running projects, and forcing a review in this fashion
> will get us there. We'd want to give clients, and ourselves, the
> opportunity to comment on any deletion candidates to save them
> from deletion.
>
> We should probably script this so that we can do it periodically.
> Since it's not a high priority, maybe we can do it in a few
> months and call it Spring Cleaning.
