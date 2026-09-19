<?php
/**
 * Plugin Name: Lemmas Hover Tooltip
 * Description: Hover/focus/tap preview tooltips for "Lemma X.Y" and
 *              "Definition X.Y" cross-references, ported from the
 *              lemmas-and-ciphers VitePress site. Purely front-end: it
 *              enqueues one small CSS file and one small JS file site-wide.
 * Version:     1.0.0
 * Author:      Lemmas & Ciphers
 * License:     MIT
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit; // Disallow direct access.
}

/**
 * Enqueue the tooltip CSS/JS on every front-end page. The script/style are
 * tiny and framework-free (no build step), so they're registered directly
 * from the plugin's assets/ directory.
 */
function lemmas_hover_tooltip_enqueue_assets() {
	$version = '1.0.0';

	wp_enqueue_style(
		'lemmas-hover-tooltip',
		plugins_url( 'assets/tooltip.css', __FILE__ ),
		array(),
		$version
	);

	wp_enqueue_script(
		'lemmas-hover-tooltip',
		plugins_url( 'assets/tooltip.js', __FILE__ ),
		array(),
		$version,
		true // load in the footer
	);
}
add_action( 'wp_enqueue_scripts', 'lemmas_hover_tooltip_enqueue_assets' );
