package com.mooc.backend.entities;

import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import io.hypersistence.utils.hibernate.type.json.JsonType;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Type;

import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@Table(name = "page_layout")
public class PageLayout {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Long id;

    @Type(JsonType.class)
    @Column(columnDefinition = "json", nullable = false)
    private PageConfig config;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "start_time")
    private LocalDateTime startTime;

    @Column(name = "end_time")
    @Temporal(TemporalType.TIMESTAMP)
    private LocalDateTime endTime;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private PageStatus status = PageStatus.DRAFT;

    @Enumerated(EnumType.STRING)
    @Column(name = "page_type", nullable = false, length = 20)
    private PageType pageType = PageType.Home;

    @Enumerated(EnumType.ORDINAL)
    @Column(nullable = false)
    private Platform platform = Platform.APP;
}
