/**
 * Utilities for validating untrusted URLs before they are used in the DOM.
 *
 * Server-supplied or user-supplied values must never be placed directly into an
 * href or src attribute, as a "javascript:" (or "data:"/"vbscript:") URI would
 * execute arbitrary script when the link is clicked or the resource is loaded.
 */

const SAFE_SCHEMES = ["http:", "https:", "mailto:"];

/**
 * Returns the URL if it uses a safe scheme, otherwise returns undefined.
 * Relative URLs (which have no scheme of their own) are resolved against the
 * current origin and are considered safe.
 *
 * @param url The untrusted URL to validate.
 */
export function sanitizeUrl(url: string | null | undefined): string | undefined {
    if (!url) {
        return undefined;
    }

    const trimmed = url.trim();

    try {
        // Resolve against the current location so relative URLs are handled.
        // The resulting protocol reflects the effective scheme of the link.
        const parsed = new URL(trimmed, window.location.origin);
        if (SAFE_SCHEMES.includes(parsed.protocol.toLowerCase())) {
            return trimmed;
        }
    } catch {
        // An unparseable URL is treated as unsafe.
    }

    return undefined;
}
