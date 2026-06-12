package org.jboss.sbomer.enhancer.core.service;

import java.util.List;
import java.util.Map;

import org.jboss.sbomer.enhancer.core.domain.EnhancementStatus;
import org.jboss.sbomer.enhancer.core.port.api.EnhancementOrchestrator;

import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class EnhancerService implements EnhancementOrchestrator {
    @Override
    public void acceptRequest(String enhancementId, String generationId, String imageRef, Map<String, String> enhancerOptions, List<String> inputSbomUrls) {

    }

    @Override
    public void handleUpdate(String enhancementId, EnhancementStatus status, String reason, List<String> resultUrls) {

    }
}
