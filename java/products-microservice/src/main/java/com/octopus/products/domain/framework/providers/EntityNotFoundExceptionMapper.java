package com.octopus.products.domain.framework.providers;

import com.octopus.exceptions.EntityNotFoundException;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.core.Response.Status;
import jakarta.ws.rs.ext.ExceptionMapper;
import jakarta.ws.rs.ext.Provider;
import lombok.NonNull;

/**
 * Converts a EntityNotFoundException exception to a HTTP response.
 */
@Provider
public class EntityNotFoundExceptionMapper implements ExceptionMapper<EntityNotFoundException> {

  @Override
  public Response toResponse(@NonNull final EntityNotFoundException exception) {
    return Response.status(Status.NOT_FOUND.getStatusCode(), "The request resource was not found")
        .build();
  }
}
