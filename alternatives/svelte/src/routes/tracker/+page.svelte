<script lang="ts">
	let count = 0;

	function handleClick() {
		count += 1;
	}
</script>

<article>
	<h1>Tracker</h1>
	<p>Track your progress on the site.</p>
	<button on:click={handleClick}>
		Clicked {count}
		{count === 1 ? 'time' : 'times'}
	</button>
</article>
