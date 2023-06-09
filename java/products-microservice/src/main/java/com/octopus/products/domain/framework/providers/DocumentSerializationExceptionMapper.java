package com.octopus.products.domain.framework.providers;

import com.github.jasminb.jsonapi.exceptions.DocumentSerializationException;
import com.octopus.features.MicroserviceNameFeature;
import io.quarkus.logging.Log;
import jakarta.inject.Inject;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.core.Response.Status;
import jakarta.ws.rs.ext.ExceptionMapper;
import jakarta.ws.rs.ext.Provider;
import lombok.NonNull;

/**
 * Converts a DocumentSerializationException to a HTTP response.
 */
@Provider
public class DocumentSerializationExceptionMapper
    implements ExceptionMapper<DocumentSerializationException> {

  @Inject
  MicroserviceNameFeature microserviceNameFeature;

  @Override
  public Response toResponse(@NonNull final DocumentSerializationException exception) {
    Log.error(microserviceNameFeature.getMicroserviceName() + "-Serialization-SerializationFailed", exception);

    return Response.status(Status.INTERNAL_SERVER_ERROR.getStatusCode(), exception.toString())
        .build();
  }
}
