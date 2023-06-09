package com.octopus.audits.domain.utilities;

import com.octopus.audits.domain.Constants;
import com.octopus.audits.domain.features.impl.AdminJwtGroupFeature;
import com.octopus.audits.domain.features.impl.DisableSecurityFeature;
import com.octopus.audits.domain.utilities.impl.JoseJwtVerifier;
import java.util.List;
import java.util.Objects;
import java.util.stream.Stream;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import org.apache.commons.lang3.StringUtils;

/**
 * A utility class with methods to extract data partition information from headers.
 */
@ApplicationScoped
public class PartitionIdentifier {

  @Inject
  JoseJwtVerifier jwtVerifier;

  @Inject
  AdminJwtGroupFeature adminJwtGroupFeature;

  @Inject
  DisableSecurityFeature cognitoDisableAuth;

  /**
   * The "Data-Partition" header contains the partition information.
   *
   * @param header The "Data-Partition" header.
   * @param jwt    The JWT from the "Authorization" header.
   * @return The partition that the request is made under, defaulting to main.
   */
  public String getPartition(final List<String> header, final String jwt) {
    /*
      The caller must be a member of a known group to make use of data partitions.
      Everyone else must work in the main partition.
     */
    if (!cognitoDisableAuth.getCognitoAuthDisabled()
        && (adminJwtGroupFeature.getAdminGroup().isEmpty()
        || StringUtils.isBlank(jwt)
        || !jwtVerifier.jwtContainsCognitoGroup(jwt, adminJwtGroupFeature.getAdminGroup().get()))) {
      return Constants.DEFAULT_PARTITION;
    }

    if (header == null || header.size() == 0 || header.stream().allMatch(StringUtils::isBlank)) {
      return Constants.DEFAULT_PARTITION;
    }

    return header.stream()
        // make sure we aren't processing null values
        .filter(Objects::nonNull)
        // split on commas for headers sent as a comma separated list
        .flatMap(h -> Stream.of(h.split(",")))
        // remove any blank strings
        .filter(s -> !StringUtils.isBlank(s))
        // trim all strings
        .map(String::trim)
        .findFirst()
        .orElse(Constants.DEFAULT_PARTITION);
  }
}
