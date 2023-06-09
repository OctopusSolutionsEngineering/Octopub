package com.octopus.audits.domain.framework.providers;

import cz.jirutka.rsql.parser.RSQLParserException;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.core.Response.Status;
import jakarta.ws.rs.ext.ExceptionMapper;
import jakarta.ws.rs.ext.Provider;
import lombok.NonNull;

/**
 * Converts a RSQLParserException exception to a HTTP response.
 */
@Provider
public class RsqlParserExceptionMapper implements ExceptionMapper<RSQLParserException> {

  @Override
  public Response toResponse(@NonNull final RSQLParserException exception) {
    return Response.status(Status.BAD_REQUEST.getStatusCode(), "The supplied filter was invalid")
        .build();
  }
}
