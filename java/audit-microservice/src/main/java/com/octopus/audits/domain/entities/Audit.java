package com.octopus.audits.domain.entities;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.github.jasminb.jsonapi.IntegerIdHandler;
import com.github.jasminb.jsonapi.annotations.Type;
import java.sql.Timestamp;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * Represents an audit JSONAPI resource and database entity. Audit records are based on the idea of
 * an RDF semantic triple, except instead of a generic predicate (Bob knows John) we assume all
 * auditable events involve actions (Bod created Document 1). Audit records may capture personally
 * identifiable information in the subject or object, in which case these values should be
 * encrypted, ideally with asymmetric encryption.
 */
@Entity
@Data
@Table(name = "audit")
@Type("audits")
public class Audit {

  @Id
  @com.github.jasminb.jsonapi.annotations.Id(IntegerIdHandler.class)
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "id")
  public Integer id;

  @NotBlank
  public String dataPartition;

  /**
   * The time the event took place.
   */
  @NotNull
  @JsonFormat(shape = JsonFormat.Shape.NUMBER, pattern = "s")
  public Timestamp time;

  /**
   * The subject that initiated the action.
   */
  @NotBlank
  public String subject;

  /**
   * The action that was taken.
   */
  @NotBlank
  public String action;

  /**
   * The object that the action was taken against.
   */
  @NotBlank
  public String object;

  /**
   * Indicates (but does not verify) that the subject in this record is encrypted.
   */
  public boolean encryptedSubject;

  /**
   * Indicates (but does not verify) that the object in this record is encrypted.
   */
  public boolean encryptedObject;
}
