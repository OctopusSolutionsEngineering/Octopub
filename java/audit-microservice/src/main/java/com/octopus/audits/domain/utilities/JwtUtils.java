package com.octopus.audits.domain.utilities;

import java.util.Optional;
import jakarta.enterprise.context.ApplicationScoped;
import org.apache.commons.lang3.StringUtils;

/** A utility class for extracting JWTs from headers. */
@ApplicationScoped
public class JwtUtils {
  private static final String BEARER = "bearer";

  /**
   * Extract the access token from the Authorization header.
   *
   * @param authorizationHeader The Authorization header.
   * @return The access token, or an empty optional if the access token was not found.
   */
  public Optional<String> getJwtFromAuthorizationHeader(final String authorizationHeader) {
    if (StringUtils.isBlank(authorizationHeader)) {
      return Optional.empty();
    }

    if (!authorizationHeader.toLowerCase().trim().startsWith(BEARER + " ")) {
      return Optional.empty();
    }

    // Assume the first header is the one we want if for some reason we got a comma separated list
    final String token = authorizationHeader.split(",")[0]
        .trim()
        .replaceFirst("(?i)" + BEARER + " ", "")
        .trim();

    if (StringUtils.isNotBlank(token)) {
      return Optional.of(token);
    }

    return Optional.empty();
  }
}
