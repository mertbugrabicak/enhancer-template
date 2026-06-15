package org.jboss.sbomer.enhancer.core.port.api;

import java.util.List;
import java.util.Map;

import org.jboss.sbomer.enhancer.core.domain.EnhancementStatus;

/**
 * Driving Port (API) for the Enhancer Core Domain.
 * <p>
 * This defines the primary use cases supported by the enhancer service:
 * 1. Accepting new requests (Ingress).
 * 2. Handling updates from the execution environment (Feedback loop).
 * </p>
 */
public interface EnhancementOrchestrator {

    /**
     * Ingress Point: Accepts a new enhancement request.
     * <p>
     * Implementations should handle buffering, throttling, or immediate execution.
     * </p>
     *
     * @param enhancementId The unique ID of the enhancement.
     * @param generationId The unique ID of the generation the enhancement belongs to.
     * @param imageRef The url of the image the enhancement belongs to. (unique to this enhancer as it needs this info)
     * @param enhancerOptions    The parameters passed for the enhancer to use.
     * @param inputSbomUrls      The list of URLs of the SBOMs to enhance.
     */
    void acceptRequest(String enhancementId, String generationId, String imageRef, Map<String, String> enhancerOptions, List<String> inputSbomUrls);

    /**
     * Feedback Point: Processes a status update from the execution environment
     * (e.g., a TaskRun finished or failed).
     *
     * @param enhancementId The unique ID of the enhancement.
     * @param status       The new status detected (FINISHED / FAILED).
     * @param reason       Human-readable reason.
     * @param resultUrls   List of result URLs (if successful).
     */
    void handleUpdate(String enhancementId, EnhancementStatus status, String reason, List<String> resultUrls);
}